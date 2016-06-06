module Event = struct

    module Replication = struct
	type t = { relationship : Relationship.t;
                         parent : CellState.t;
                          child : CellState.t
		 }

	let make r p c = { relationship = r;
                                 parent = p;
                                  child = c
			 } 
      end

    module SelfClotting = struct
	type t = { relationship : Relationship.t;
                        previus : CellState.t;
                        current : CellState.t
		 }

	let make r p c = { relationship = r;
                                previus = p;
                                current = c
			 } 
      end

    module Turning = struct
	type t = {      side : HandSide.t;
	           prev_gaze : HexagonSide.t;
		     current : CellState.t
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
	     | Started of CellState.t

    let replicated_out ~relationship:r ~parent:p ~child:c =
      ReplicatedOut (Replication.make r p c)

    let self_clotted ~relationship:r ~previus:p ~current:c =
      SelfClotted (SelfClotting.make r p c)

    let replicated ~relationship:r ~parent:p ~child:c = 
      Replicated (Replication.make r p c)

    let turned ~side:s ~prev_gaze:p ~current:c = 
      Turned (Turning.make s p c)

    let start_failed hexagon = 
      StartFailed hexagon

    let started state = 
      Started state
  
  end

type t = { cell : Cell.t;
           next : Event.t -> unit
         }

let state_of o =
  Cell.state_of o.cell

let first set i next =
  match Cell.first set i with 
  
  | Some cell -> 
     let () = next (Event.started (Cell.state_of cell)) in
     Some { cell; next; }
  
  | None      -> 
     let () = next (Event.start_failed (Set.get i set)) in
     None

let turn side o =
  let prev_gaze = (Cell.state_of o.cell).body.gaze in
  let cell = Cell.turn side o.cell in 
  let () = o.next (Event.turned ~side
			   ~prev_gaze: prev_gaze
                             ~current: (Cell.state_of cell))
  in

  { o with cell }

let replicate ~relationship:r 
                     ~donor:o =

  let open ReplicationResult in 

  match Cell.replicate 
                 ~relationship: r 
                        ~donor: o.cell with
  | Replicated cell  -> 
     let () = o.next (Event.replicated 
                        ~relationship: r 
	                      ~parent: (state_of o) 
	                       ~child: (Cell.state_of cell))
     in
     
     Replicated { o with cell }

  | SelfClotted cell ->
     let () = o.next (Event.self_clotted
		        ~relationship: r 
		             ~previus: (state_of o) 
		             ~current: (Cell.state_of cell))
     in

     SelfClotted { o with cell }

  | ReplicatedOut cell ->
     let () = o.next (Event.replicated_out
                        ~relationship: r
		              ~parent: (state_of o) 
		               ~child: (Cell.state_of cell))
     in

     ReplicatedOut { o with cell }
