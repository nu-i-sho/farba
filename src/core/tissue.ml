module Coord = struct
  module Key = struct
    type t = int * int
    let compare (x1, y1) (x2, y2) =
      match  compare y1 y2 with
      | 0 -> compare x1 x2
      | n -> n
    end

  include Key
              
  module Set = Set.Make (Key)
  module Map = Map.Make (Key)
             
  let zero = 0, 0
  let none = Int.min_int, Int.min_int
  let is_none = (=) none  
  
  let move side (x, y) =
    let dx, dy =
      match x mod 2, side with
        
      | 0, Side.Up        ->  0, -1  
      | 0, Side.LeftUp    -> -1, -1
      | 0, Side.RightUp   -> +1, -1
      | 0, Side.Down      ->  0, +1
      | 0, Side.LeftDown  -> -1,  0
      | 0, Side.RightDown -> +1,  0
                           
      | 1, Side.Up        ->  0, -1
      | 1, Side.LeftUp    -> -1,  0
      | 1, Side.RightUp   -> +1,  0
      | 1, Side.Down      ->  0, +1 
      | 1, Side.LeftDown  -> -1, +1
      | 1, Side.RightDown -> +1, +1
                           
      | _        -> assert false in
    
    x + dx,
    y + dy
    
  end

module Tissue = struct 
  type t =
    { cytoplasms : Pigment.t Coord.Map.t;
       nucleuses : Nucleus.t Coord.Map.t;
            clot : Coord.t;
          cursor : Coord.t
    }

  let cytoplasm     i o = o.cytoplasms |> Coord.Map.find i 
  let cytoplasm_opt i o = o.cytoplasms |> Coord.Map.find_opt i
                      
  let nucleus     i o = o.nucleuses |> Coord.Map.find i
  let nucleus_opt i o = o.nucleuses |> Coord.Map.find_opt i
                      
  let cursor o = o.cursor
  let clot o = o.clot
  end

include Tissue           
                    
module Constructor = struct
  module Command = struct
    type t =
      | Move of Side.t
      | Add_cytoplasm of Pigment.t
      | Add_nucleus of Nucleus.t
      | Set_cursor
      | Set_clot
    end

  module Tissue = struct
    type t = Tissue.t

    let empty =
      { cytoplasms = Coord.Map.empty;
         nucleuses = Coord.Map.empty;
              clot = Coord.none;
            cursor = Coord.none
      }
                  
    let add_cytoplasm i x o =
      let cytoplasms = Coord.Map.add i x o.cytoplasms in
      { o with cytoplasms
      }
      
    let add_nucleus i x o =
      let nucleuses = Coord.Map.add i x o.nucleuses in
       { o with nucleuses
       }
      
    let set_cursor i o = { o with cursor = i }
    let set_clot   i o = { o with clot = i }
 
    end

  type t =
    { possition : Coord.t;
         tissue : Tissue.t;
    }
                
  let empty =
    { possition = Coord.zero;
         tissue = Tissue.empty
    }

  let perform command o =
    let i = o.possition
    and t = o.tissue in
    match command with
    | Command.Move side       -> { o with possition = Coord.move side i }
    | Command.Add_cytoplasm x -> { o with tissue = Tissue.add_cytoplasm i x t }
    | Command.Add_nucleus   x -> { o with tissue = Tissue.add_nucleus i x t }
    | Command.Set_cursor      -> { o with tissue = Tissue.set_cursor i t }
    | Command.Set_clot        -> { o with tissue = Tissue.set_clot i t }
    
  let product o =
    o.tissue
    
  end

module Destructor = struct
  module Command = Constructor.Command
  module Tissue = struct
    include Tissue

    let is_empty o =
      (o.cytoplasms |> Coord.Map.is_empty) &&
       (o.nucleuses |> Coord.Map.is_empty) &&
            (o.clot |> Coord.is_none)      &&
          (o.cursor |> Coord.is_none)
      
    type cell = { cytoplasm : Pigment.t option;
                    nucleus : Nucleus.t option;
                    is_clot : bool;
                  is_cursor : bool
                }
              
    module Cell = struct
      type t = Coord.t * cell

      let neighbor_coord (i, _) side =
        Coord.move side i
        
      let exists =
        function (_, { cytoplasm = None;
                         nucleus = None;
                         is_clot = false;
                       is_cursor = false
                     }
                 ) -> false
               | _ -> true

      let to_commands (_, cell) =
        ( let to_command c = Command.Add_cytoplasm c in  
          Option.map to_command cell.cytoplasm

        ) :: ( if cell.is_clot then
                 Some Command.Set_clot else

                 let to_command n = Command.Add_nucleus n in
                 Option.map to_command cell.nucleus

             ) :: ( if cell.is_cursor then
                      [Some Command.Set_cursor] else
                      []
                  )
      end

    let remove_cell o i =
      let is_clot   = i = o.clot
      and is_cursor = i = o.cursor in
      
      { cytoplasms = Coord.Map.remove i o.cytoplasms;
         nucleuses = Coord.Map.remove i o.nucleuses;
              clot = if is_clot   then Coord.none else clot o;
            cursor = if is_cursor then Coord.none else cursor o
                     
      }, ( i, { cytoplasm = cytoplasm_opt i o;
                  nucleus = nucleus_opt i o;
                  is_clot;
                is_cursor  
              }
         )
    end

  module SideMap = Map.Make (Side)
                   
  type node =
    {    value : Tissue.Cell.t;
      children : (Side.t * node) List.t  
    }

  type e =
    | Commands of Command.t option list
    | Nodes of (Side.t * node) List.t
               
  type t = e list
  
  let make tissue =    
    let rec build_tree tissue cell =
      let when_fst f (x, _) = f x in
      
      let tissue, children =
        Side.all |> List.map (Tissue.Cell.neighbor_coord cell)
                 |> List.fold_left_map Tissue.remove_cell tissue in
      let children, sides =
        Side.all |> List.combine children 
                 |> List.filter (when_fst Tissue.Cell.exists)
                 |> List.split in
      let tissue, children = 
        children |> List.fold_left_map build_tree tissue in
      let children = 
        children |> List.combine sides in

      tissue, { value = cell;
                children
              } in

    let tissue, root_cell = Tissue.remove_cell tissue Coord.zero in
    let tissue, tree = build_tree tissue root_cell in
    assert (Tissue.is_empty tissue);
    
    [ Commands (Tissue.Cell.to_commands tree.value);
      Nodes tree.children
    ]
    
  let rec next = function  
    | []                                   -> None, []
    | (Commands [] | Nodes [])        :: t -> next t
    | (Commands (None :: cmds))       :: t -> next ((Commands cmds) :: t)  
    | (Commands (cmd  :: cmds))       :: t -> cmd, ((Commands cmds) :: t)
    | (Nodes ((side, node) :: nodes)) :: t ->

       Some (Command.Move side), [
          Commands (Tissue.Cell.to_commands node.value);
          Nodes    (node.children); 
          Commands [Some (Command.Move (Side.rev side))];
          Nodes    (List.remove_assoc side nodes)
        ]
  end
                   
module Cursor = struct
  module Command = struct
    type t =
      | Turn of Hand.t
      | Move of Nature.t
      | Replicate of Gene.t
    end
                 
  module Tissue  = struct
    include Tissue

    let set_cursor i o =
      { o with cursor = i
      }
      
    let set_nucleus i x o =
      { o with nucleuses = Coord.Map.set i x o.nucleuses
      } |> set_cursor i

    let remove_nucleus i o =
      { o with nucleuses = Coord.Map.remove i o.nucleuses
      }

    let set_clot i o = 
      { o with clot = i;
      } |> set_cursor i
      
    end

  type t = Tissue.t
                 
  let make tissue = tissue
  let tissue    o = o
  let possition o = o.cursor 

  let is_clotted o =
    not (Coord.is_none o.clot)

  let is_out_of_tissue o =
    let i = possition o in
    not (Coord.Map.mem i o.cytoplasms)
  
  let turn hand o =
    let i = o |> possition in
    let n = o |> Tissue.nucleus i
              |> Nucleus.turn hand in
    Tissue.set_nucleus i n o

  let move o =
    let i = possition o in
    let open Pigment in

    match cytoplasm i o with
    | Blue | Gray -> o
    | White       ->
       let n  = o |> Tissue.nucleus i in
       let o  = o |> Tissue.remove_nucleus i
       and i' = i |> Coord.move n.gaze in
       ( match (o |> Tissue.nucleus_opt   i'),
               (o |> Tissue.cytoplasm_opt i') with
         |  None,     None                -> Tissue.set_nucleus i' n 
         |  None,    (Some c')            -> let n' = Nucleus.inject c' n in
                                             Tissue.set_nucleus i' n' 
         | (Some _), (Some White)         -> let n' = Nucleus.look_back n in
                                             Tissue.set_nucleus i  n'
         | (Some _), (Some (Blue | Gray)) -> Tissue.set_clot i'
         | (Some _),  None                -> assert false
     ) o

  let replicate gene o =
    let i = possition o in
    let open Pigment in
  
    match Tissue.cytoplasm i o with
    | White        -> o
    | Blue | Gray  ->
       let parent = Tissue.nucleus i o in
       let j = Coord.move parent.gaze i 
       and child  = Nucleus.replicate gene parent in
       ( match (Tissue.nucleus_opt   j o),
               (Tissue.cytoplasm_opt j o) with
         |  None,     None                -> Tissue.set_nucleus j child 
         |  None,    (Some c)             -> let n = Nucleus.inject c child in
                                             Tissue.set_nucleus j n 
         | (Some _), (Some White)         -> Tissue.set_clot i
         | (Some _), (Some (Blue | Gray)) -> Tissue.set_clot j
         | (Some _),  None                -> assert false
       ) o

  let pass o =
    let i  = possition o in
    let donor = Tissue.nucleus i o in
    let i' = Coord.move donor.gaze i in
    
    match nucleus_opt i' o with
    | None           -> o
    | Some recipient ->
       let face_to_face =
         donor.gaze == (Side.rev recipient.gaze) in
       if face_to_face then
         o |> Tissue.set_cursor i' else
         o

  exception Clotted
  exception Out_of_tissue
        
  let perform command o =
    if o |> is_clotted then raise Clotted else
    if o |> is_out_of_tissue then raise Out_of_tissue else
      ( match command with
        | Command.Replicate gene   -> replicate gene
        | Command.Turn direction   -> turn direction
        | Command.Move Nature.Body -> move
        | Command.Move Nature.Mind -> pass
      ) o
    
  end
