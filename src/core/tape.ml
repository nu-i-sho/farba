module EnergyOpt = struct
  module Make (E : Energy.STAGE) = struct
    type t = E.t option
           
    let value = function
      | Some x -> Some (E.value x)
      | None   -> None 
    end
  end

module EWaitOpt = EnergyOpt.Make (Energy.Wait)
module EMarkOpt = EnergyOpt.Make (Energy.Mark)

module Cell = struct
  type t =
    ( Command.t,
      Dots.t * EWaitOpt.t,
      Dots.t * EMarkOpt.t
    ) Statement.t
 
  let of_src = 
    Statement.( function
      | Perform x -> Perform  x
      | Call    x -> Call    (x, None)
      | Declare x -> Declare (x, None)
    )
    
  let to_src =
    Statement.( function
      | Perform  x     -> Perform x
      | Call    (x, _) -> Call    x
      | Declare (x, _) -> Declare x
    )
  end

module Stage = struct
  type t =
    | Call of Energy.Call.t
    | Back of Energy.Back.t
    | Find of Energy.Find.t
  end

module Part = struct
  type t =
    | Prev of (int * Cell.t) list
    | Next of (int * Cell.t) list
  end
             
type t =
  { stage : Stage.t;
     prev : (int * Cell.t) list;
     next : (int * Cell.t) list
  }
             
module Head = struct
  module Link = struct          
    type t =
      | Start
      | Cell of Cell.t 
      | End
    end

  let containing_part o =
    match o.stage with
    | Stage.(Call _ | Find _) -> Part.Prev o.prev
    | Stage.(Back _)          -> Part.Next o.next
              
  let celli o =
    let Part.(Next x | Prev x) = containing_part o in
    List.hd_opt x

  let index o =
    o |> celli
      |> Option.map fst

  let cell o =
    o |> celli
      |> Option.map snd

  let change_cell x o = 
    match containing_part o with
    | Part.(Next ((i, _) :: t)) -> { o with next = (i, x) :: t }
    | Part.(Prev ((i, _) :: t)) -> { o with prev = (i, x) :: t }
    | Part.(Prev [] | Next [])  -> assert false
    
  let change_wait e o =
    match cell o with
    | Some Statement.(Call (procedure, _))
           -> change_cell Statement.(Call (procedure, e)) o
    | Some Statement.(Perform _ | Declare _)
    | None -> assert false

  let change_mark e o =
    match cell o with
    | Some Statement.(Declare (procedure, _))
           -> change_cell Statement.(Declare (procedure, e)) o
    | Some Statement.(Perform _ | Call _)
    | None -> assert false

  let stage o = o.stage
  let link  o =
    match (cell o), o.stage with
    | (Some x), Stage.(Call _ | Find _ | Back _) -> Link.Cell x
    |  None,    Stage.(Call _ | Find _         ) -> Link.Start
    |  None,    Stage.(                  Back _) -> Link.End

  let change_stage x o =
    { o with stage = x
    }
                                                  
  let set_wait e  = change_wait (Some e)
  let remove_wait = change_wait  None
                  
  let mark e = change_mark (Some e)
  let unmark = change_mark  None
                
  let move o =
    match o.stage, o.next, o.prev with
    | Stage.(Call _ | Find _), (h :: t), prev ->
       { o with
         prev = h :: prev;
         next = t
       }
    | Stage.(Back _), next, (h :: t) ->
       { o with
         next = h :: next;
         prev = t
       }
    | Stage.(Call _ | Find _ | Back _), _, _ ->
       assert false     
  end 
         
let start source =
  let pair a b = a, b in
  let next =
    source |> List.map Cell.of_src
           |> List.mapi pair in
  { stage = Stage.Call Energy.origin;
     prev = [];
     next
  }

let cellsi o =
  List.rev_append
    o.prev
    o.next

let cells o =
  o |> cellsi
    |> List.map snd
  
let source o =
  o |> cells
    |> List.map Cell.to_src

let cell i o =
  ( match o.prev, o.next with
    | ((j, _) :: _), _ when i <= j -> o.prev
    | _, ((j, _) :: _) when i >= j -> o.next
    | _ -> assert false
  ) |> List.assoc i

let insert i x o =
  assert (i >= 0);
  
  let into_part = 
    match List.hd_opt o.next with
    | Some (j, _) when j = i    -> Head.containing_part o
    | Some (j, _) when j > i    -> Part.Next o.next
    | Some _ (* j < i *) | None -> Part.Prev o.prev
  and cell = i, (Cell.of_src x)
  and succ (i, x) = (succ i), x in
  
  match into_part with
  | Part.Next n ->
     let rec insert acc = function
       | ((j, _) as h) :: t when j = i
                -> t |> List.map succ
                     |> List.rev_append (cell :: (succ h) :: acc)
       | ((j, _) as h) :: [] when j = pred i
                -> List.rev (cell :: (succ h) :: acc)
       | h :: t -> t |> insert (h :: acc)
       | []     -> assert false in
     { o with
       next = insert [] n 
     }
  | Part.Prev p ->
     let rec insert acc = function
       | ((j, _) as h) :: t when j = i
                -> t |> List.rev_append (cell :: (succ h) :: acc)
       | h :: t -> t |> insert ((succ h) :: acc)
       | []     -> assert false in
     { o with
       next = List.map succ o.next;
       prev = insert [] p
     }

let remove i o =
  assert (i >= 0);
  assert (
      match Head.index o with
      | Some j when j = i -> false
      | Some _ | None     -> true
    );

  let pred (i, x) = (pred i), x in
  let removed, next =
    match List.hd_opt o.next with
    | Some (j, _) when j >= i ->
       let rec remove acc = function
         | (j, _) :: t when j = i
                  -> t |> List.map pred
                       |> List.rev_append acc
         | h :: t -> t |> remove (h :: acc)
         | []     -> assert false in
       true, (o.next |> remove [])  
    | Some _ | None           ->
       false, o.next in
    
  let prev, next =
    if removed then o.prev, o.next else
      let rec remove acc = function
        | (j, _) :: t when j = i
                 -> (List.rev_append acc t),
                    (List.map pred o.next)
        | h :: t -> (remove ((pred h) :: acc) t)
        | []     ->  assert false in
        remove [] o.prev in
    { o with
      prev;
      next
    }
