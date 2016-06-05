type t = {  body : Protocell.t;
           index : Set.Index.t;
             set : Set.t
         }

type start_result_t =
  | ImpossibleToStartFromNonEmptyHexagon
  | Started of t

let start ~level:set ~start:index =
  let hexagon = Set.get index set in
  match hexagon with
  | Empty -> Started { body = Protocell.first; index; set }
  | _     -> ImpossibleToStartFromNonEmptyHexagon

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
      	     
type replication_result_t = 
  | ReplicatedToOutOfWorld
  | Replicated of t
  | SelfCloted of t

let replicate ~relationship:r ~donor:farba =
  let (index', maybe_acceptor) = 
    neighbor farba.body.gaze farba 
  in

  match maybe_acceptor with
  | None          -> ReplicatedToOutOfWorld
  | Some acceptor -> 
     let with_set farba =
       let value = Set.Value.Cell farba.body in
       let () = Set.set farba.index value farba.set in 
       farba 
     in

     match acceptor with
     | Set.Value.Empty -> 
	let child = Protocell.replicate
		      ~relationship:r 
                             ~donor:farba.body 
	in
	
	Replicated ({ farba with index = index';
                                  body = child
		    } |> with_set)

     | Set.Value.Cytoplazm c ->
	let child = Protocell.replicate_to_cytoplazm 
		      ~relationship:r 
		             ~donor:farba.body
		          ~acceptor:c
	in
	
	Replicated ({ farba with index = index';
                                  body = child 
		    } |> with_set)

     | Set.Value.Cell c -> 
	let parent, child = Protocell.replicate_to_protocell
			      ~relationship:r 
		                     ~donor:farba.body
		                  ~acceptor:c
	in

	let open Protocell.Kind in
	match Protocell.kind_of parent with
	| Cancer
	| Hels -> Replicated ({ farba with index = index';
                                            body = child   
			     } |> with_set)
	| Clot -> SelfCloted ({ farba with body = parent 
			     } |> with_set)
