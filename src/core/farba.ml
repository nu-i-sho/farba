type t = { celluar : Celluar.t;
             index : Set.Index.t;
               set : Set.t
         }

type start_result_t =
  | ImpossibleToStartFromNonEmptyHexagon
  | Started of t

let start ~level:set ~start:index =
  let hexagon = Set.get index set in
  match hexagon with
  | Empty -> Started { celluar = Celluar.first; index; set }
  | _     -> ImpossibleToStartFromNonEmptyHexagon

let neighbor side o = 
  let index' = Set.Index.move side o.index in
  if Set.is_in_range index' o.set then
    (index', Some (Set.get index' o.set)) else
    (index', None)

let turn side o = 
  let celluar = Celluar.turn side o.celluar in
  let value = Set.Value.Celluar celluar in
  let () = Set.set o.index value o.set in
  { o with celluar }
      	     
type replication_result_t = 
  | ReplicatedToOutOfWorld
  | Replicated of t
  | SelfCloted of t

let replicate ~relationship:r ~donor:farba =
  let (index', maybe_acceptor) = 
    neighbor farba.celluar.gaze farba 
  in

  match maybe_acceptor with
  | None          -> ReplicatedToOutOfWorld
  | Some acceptor -> 
     let with_set farba =
       let value = Set.Value.Celluar farba.celluar in
       let () = Set.set farba.index value farba.set in 
       farba 
     in

     match acceptor with
     | Set.Value.Empty -> 
	let child = Celluar.replicate
		      ~relationship:r 
                             ~donor:farba.celluar 
	in
	
	Replicated ({ farba with celluar = child;
                                   index = index'
		    } |> with_set)

     | Set.Value.Cytoplazm cytoplazm ->
	let child = Celluar.replicate_to_cytoplazm 
		      ~relationship:r 
		             ~donor:farba.celluar
		          ~acceptor:cytoplazm
	in
	
	Replicated ({ farba with celluar = child;
                                   index = index'
		    } |> with_set)

     | Celluar celluar -> 
	let parent, child = Celluar.replicate_to_celluar
			      ~relationship:r 
		                     ~donor:farba.celluar
		                  ~acceptor:celluar
	in

	let open Celluar.Kind in
	match Celluar.kind_of parent with
	| Cancer
	| Hels -> Replicated ({ farba with celluar = child;
                                             index = index' 
			     } |> with_set)
	| Clot -> SelfCloted ({ farba with celluar = parent 
			     } |> with_set)
