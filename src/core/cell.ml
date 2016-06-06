type t = {  body : Protocell.t;
           index : Set.Index.t;
             set : Set.t
         }

let first set index =
  let hexagon = Set.get index set in
  match hexagon with
  | Empty -> let body = Protocell.first in
             Some { body; index; set }
  | _     -> None

let state_of { body; index; _ } =
  CellState.({ body; index })

let neighbor side o = 
  let i' = Set.Index.move side o.index in
  if Set.is_in_range i' o.set then
    (i', Some (Set.get i' o.set)) else
    (i', None)

let turn side o = 
  let turned = Protocell.turn side o.body in
  let value = Set.Value.Cell turned in
  let () = Set.set o.index value o.set in
  { o with body = turned }

let replicate ~relationship:r ~donor:cell =
  let (index', maybe_acceptor) = 
    neighbor cell.body.gaze cell
  in
  let open ReplicationResult in
  match maybe_acceptor with
  | None          ->
     let child = Protocell.replicate
                   ~relationship:r
                          ~donor:cell.body
     in
	
     ReplicatedOut ({ cell with index = index';
                                 body = child
		   })
  | Some acceptor -> 
     let with_set farba =
       let value = Set.Value.Cell cell.body in
       let () = Set.set cell.index value cell.set in 
       cell
     in

     match acceptor with
     | Set.Value.Empty -> 
	let child = Protocell.replicate
		      ~relationship:r 
                             ~donor:cell.body 
	in
	
	Replicated ({ cell with index = index';
                                 body = child
		    } |> with_set)

     | Set.Value.Cytoplasm c ->
	let child = Protocell.replicate_to_cytoplasm 
		      ~relationship:r 
		             ~donor:cell.body
		          ~acceptor:c
	in
	
	Replicated ({ cell with index = index';
                                 body = child 
		    } |> with_set)

     | Set.Value.Cell c -> 
	let parent, child = Protocell.replicate_to_protocell
			      ~relationship:r 
		                     ~donor:cell.body
		                  ~acceptor:c
	in

	let open Protocell.Kind in
	match Protocell.kind_of parent with
	| Cancer
	| Hels -> Replicated ({ cell with index = index';
                                           body = child   
			     } |> with_set)
	| Clot -> SelfClotted ({ cell with body = parent 
			       } |> with_set)
