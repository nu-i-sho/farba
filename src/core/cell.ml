module State = struct
    type t = { value : Protocell.t;
	       index : Set.Index.t
             }
  end

module Event = struct

    module Replication = struct
	type t = { relationship : Relationship.t;
                         parent : State.t;
                          child : State.t
		 }

	let make r p c = { relationship = r;
                                 parent = p;
                                  child = c
			 } 
      end

    module SelfClotting = struct
	type t = { relationship : Relationship.t;
                        previus : State.t;
                        current : State.t
		 }

	let make r p c = { relationship = r;
                                previus = p;
                                current = c
			 } 
      end

    module Turning = struct
	type t = {      side : HandSide.t;
	           prev_gaze : HexagonSide.t;
		     current : State.t
		 }

	let make s p c = {      side = s;
	                   prev_gaze = p;
		             current = c;
                         }
      end

    type t = | ReplicatedOut of Replication.t
             | SelfClotted of SelfClotting.t 
             | Replicated of Replication.t
             | Turned of Turning.t
	     | StartFailed of Set.Value.t
	     | Started of State.t

    let replicated_out ~relationship:r ~parent:p ~child:c =
      lazy(ReplicatedOut (Replication.make r p c))

    let self_clotted ~relationship:r ~previus:p ~current:c =
      lazy(SelfClotted (SelfClotting.make r p c))

    let replicated ~relationship:r ~parent:p ~child:c = 
      lazy(Replicated (Replication.make r p c))

    let turned ~side:s ~prev_gaze:p ~current:c = 
      lazy(Turned (Turning.make s p c))

    let start_failed hexagon = 
      StartFailed hexagon

    let started state = 
      Started state
  
  end

type t = {  body : Protocell.t;
           index : Set.Index.t;
             set : Set.t;
            next : (Event.t -> unit) option
         }

type start_result_t = | StartFailed of Set.Value.t 
                      | Started of t

let next event o =
  match o.next with
  | Some f -> f (Lazy.force event)
  | None   -> ()

let state_of o =
  State.({ value = o.body;
	   index = o.index
        })

let start ~level:set ~start:index =
  let hexagon = Set.get index set in
  match hexagon with
  | Empty -> Started { body = Protocell.first; 
		       next = None;
		       index; 
		       set
		     }
  | _     -> StartFailed hexagon

let starto ~level:set ~start:index ~observer:next = 
  let result = start ~level:set ~start:index in
  let () = match result with
           | Started cell        -> 
	      next (Event.started (state_of cell))
	   | StartFailed hexagon ->
	      next (Event.start_failed hexagon)
  in

  result

let neighbor side o =
  let index' = Set.Index.move side o.index in
  if Set.is_in_range index' o.set then
    (index', Some (Set.get index' o.set)) else
    (index', None)

let turn side o = 
  let c = Protocell.turn side o.body in
  let value = Set.Value.Cell c in
  let () = Set.set o.index value o.set in
  let o' = { o with body = c } in
  let () = o |> next (Event.turned ~side
                        ~prev_gaze:(o.body.gaze)
                          ~current:(state_of o'))
  in
  o'
      	     
type replication_result_t = | SelfClotted of t
                            | Replicated of t
			    | ReplicatedOut

let replicate ~relationship:r ~donor:o =
  let (index', maybe_acceptor) = 
    neighbor o.body.gaze o
  in

  let with_set o =
    let value = Set.Value.Cell o.body in
    let () = Set.set o.index value o.set in 
    o
  in

  match maybe_acceptor with
  | None          -> 
     let child = State.({ index = index';
			  value = Protocell.replicate 
				    ~relationship:r 
				           ~donor:o.body
			})
     in

     let () = o |> next (Event.replicated_out
                            ~relationship:r 
		                  ~parent:(state_of o) 
		                   ~child:child)
     in

     ReplicatedOut

  | Some Set.Value.Empty ->  
     let child = Protocell.replicate
		   ~relationship:r 
                          ~donor:o.body 
     in
	
     let () = o |> next (Event.replicated 
		           ~relationship:r 
		                 ~parent:(state_of o) 
		                  ~child:{ index = index';
                                           value = child 
		                         })
     in

     Replicated ({ o with index = index';
                          body = child
		 } |> with_set)

  | Some (Set.Value.Cytoplasm c) ->
     let child = Protocell.replicate_to_cytoplasm 
		   ~relationship:r 
		          ~donor:o.body
		       ~acceptor:c
	in

	let () = o |> next (Event.replicated 
		              ~relationship:r 
		                    ~parent:(state_of o) 
		                     ~child:{ index = index';
                                              value = child 
		                            })
	in
	
	Replicated ({ o with index = index';
                              body = child 
		    } |> with_set)

  | Some (Set.Value.Cell c) -> 
     let parent, child = Protocell.replicate_to_protocell
			   ~relationship:r 
		                  ~donor:o.body
		               ~acceptor:c
     in

     let open Protocell.Kind in
     match Protocell.kind_of parent with
     | Cancer
     | Hels ->
	let () = o |> next (Event.replicated 
                              ~relationship:r 
		                    ~parent:(state_of o) 
		                     ~child:{ index = index';
                                              value = child 
		                            })
	in
 
	Replicated ({ o with index = index';
                              body = child   
		    } |> with_set)

     | Clot ->
	let () = o |> next (Event.self_clotted
		              ~relationship:r 
		                   ~previus:(state_of o) 
		                   ~current:{ index = o.index;
                                              value = parent 
		                            })
	in

	SelfClotted ({ o with body = parent 
		     } |> with_set)
