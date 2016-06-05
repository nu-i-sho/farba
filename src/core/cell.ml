type t = {  body : Protocell.t;
           index : Set.Index.t;
             set : Set.t
         }

type rep_res_t = | SelfClotted of t
		 | Replicated of t
		 | ReplicatedOut

let start ~level:set ~start:index =
  let hexagon = Set.get index set in
  match hexagon with
  | Empty -> Some { body = Protocell.first; index; set }
  | _     -> None

let neighbor side o = 
  let index' = Set.Index.move side o.index in
  if Set.is_in_range index' o.set then
    (index', Some (Set.get index' o.set)) else
    (index', None)

let turn side o = 
  let c = Protocell.turn side o.body in
  let value = Set.Value.Cell c in
  let () = Set.set o.index value o.set in
  { o with body = c }

let replicate ~relationship:r ~donor:cell =
  let (index', maybe_acceptor) = 
    neighbor cell.body.gaze cell
  in

  match maybe_acceptor with
  | None          -> ReplicatedOut
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
