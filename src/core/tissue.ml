module Coord = struct
  type t = int * int

  module Map = Map.Make
    ( struct
        type nonrec t = t
                    
        let compare (x1, y1) (x2, y2) =
          match  compare y1 y2 with
          | 0 -> compare x1 x2
          | n -> n
        end
    )

  let zero = 0, 0
  let none = Int.max_int, Int.max_int
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
             
type t =
  { cytoplasms : Pigment.t Coord.Map.t;
     nucleuses : Nucleus.t Coord.Map.t;
          clot : Coord.t;
        cursor : Coord.t
  }
  
let empty =
  { cytoplasms = Coord.Map.empty;
     nucleuses = Coord.Map.empty;
          clot = Coord.none;
        cursor = Coord.none
  }
    
let is_in     i o = Coord.Map.mem i o.cytoplasms
let is_out_of i o = not (is_in i o)
   
let clot o = o.clot
let has_clot o = not (Coord.is_none o.clot)

let remove_clot o =
  { o with clot = Coord.none
  }

let set_clot i o = 
  { o with
      clot = i;
    cursor = i
  }

let cursor o = o.cursor

let set_cursor i o =
  { o with cursor = i
  }
  
let add_cursor i o =
  let () = assert (Coord.is_none o.cursor) in
  set_cursor i o
                 
let cytoplasm     i o = o.cytoplasms |> Coord.Map.find i 
let cytoplasm_opt i o = o.cytoplasms |> Coord.Map.find_opt i

let nucleus     i o = o.nucleuses |> Coord.Map.find i
let nucleus_opt i o = o.nucleuses |> Coord.Map.find_opt i
             
let set_nucleus i x o =
  let n = Coord.Map.set i x o.nucleuses in 
  { o with
    nucleuses = n;
       cursor = i
  }

let remove_nucleus i o =
  let n = Coord.Map.remove i o.nucleuses in
  { o with nucleuses = n
  }

module Builder = struct
  type nonrec t = t * Coord.t
                
  let empty =
    empty, Coord.zero

  let add_cytoplasm x (o, i) =
    let c = Coord.Map.add i x o.cytoplasms in
    { o with cytoplasms = c }, i

  let add_nucleus pigment gaze (o, i) =
    let x = Nucleus.make pigment gaze in
    let n = Coord.Map.add i x o.nucleuses in
    { o with nucleuses = n }, i

  let set_cursor (o, i) =
    set_cursor i o, i

  let move_coord direction (o, i) =
    o, Coord.move direction i

  let product (o, _) =
    o

  end
