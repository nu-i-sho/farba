module EnergyOpt = struct
  module Make (E : Energy.STAGE) = struct
    type t = E.t option
           
    let value = function
      | Some x -> Some (E.value x)
      | None   -> None

    let load src =
      match Seq.skip_opt '0' src with
      | Some next -> None, next
      | None      ->
         let x, next = E.load src in
         Some x, next

    let unload = function
      | Some x -> E.unload x
      | None   -> Seq.return '0' 
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

  let load src =
    let statement, next = Source.Element.load src in
    Statement.(
      match statement with
      | Perform x -> Perform x, next
      | Call    x -> let wait, next = EWaitOpt.load next in
                     Call (x, wait), next
      | Declare x -> let mark, next = EMarkOpt.load next in
                     Declare (x, mark), next 
    )

  let unload o =
    Seq.append
      (o |> to_src
         |> Source.Element.unload)
      ( match o with
         | Statement.Perform  _     -> Seq.empty
         | Statement.Call    (_, e) -> EWaitOpt.unload e
         | Statement.Declare (_, e) -> EMarkOpt.unload e
      )
  end

module Stage = struct
  type t =
    | Call of Energy.Call.t
    | Back of Energy.Back.t
    | Find of Energy.Find.t

  let load src =
    match src () with
    | Seq.Cons ('C', next) ->
       let x, next = Energy.Call.load next in
       (Call x), next
    | Seq.Cons ('B', next) ->
       let x, next = Energy.Back.load next in
       (Back x), next
    | Seq.Cons ('F', next) ->
       let x, next = Energy.Find.load next in
       (Find x), next
    | Seq.Cons _ | Seq.Nil ->
       assert false

  let unload = function
    | Call x -> Seq.append (Seq.return 'C') (Energy.Call.unload x)
    | Back x -> Seq.append (Seq.return 'B') (Energy.Back.unload x)
    | Find x -> Seq.append (Seq.return 'F') (Energy.Find.unload x)   
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

let load src =
  let stage, src = Stage.load src in
  let src = Seq.skip ',' src in
  let rec load_cells end_mark acc src =
    match src () with
    | Seq.Nil            -> assert false
    | Seq.Cons (x, src') ->
       if x = end_mark then
         List.rev acc, src' else
         let cell, src' = Cell.load src in
         load_cells end_mark (cell :: acc) src' in
  let celli i cell = i, cell in
  let prev, src = load_cells ',' [] src in
  let prev = List.rev (List.mapi celli prev) in
  let next, src = load_cells '.' [] src in
  let top_prev_i =
    match prev with
    | (i, _) :: _ -> i
    | []          -> 0 in
  let celli i = celli (i + top_prev_i) in
  let next = List.mapi celli next in
  { stage; prev; next }, src

let unload o =
  let unload_cells x =
    x |> List.to_seq
      |> Seq.map snd
      |> Seq.map Cell.unload
      |> Seq.fold_left Seq.append Seq.empty in

  [ Stage.unload o.stage;
    Seq.return ',';
    unload_cells o.prev;
    Seq.return ',';
    unload_cells o.next;
    Seq.return '.'

  ] |> List.fold_left Seq.append Seq.empty
    
    
