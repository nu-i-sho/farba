module Event : sig

    module Replication : sig
	type t = private { relationship : Relationship.t;
                                 parent : CellState.t;
                                  child : CellState.t
			 }
      end

    module SelfClotting : sig
	type t = private { relationship : Relationship.t;
                                previus : CellState.t;
                                current : CellState.t
			 }
      end

    module Turning : sig
	type t = private {      side : HandSide.t;
	                   prev_gaze : HexagonSide.t;
		             current : CellState.t
			 }

      end

    type t = private | ReplicatedOut of Replication.t
		     | SelfClotted of SelfClotting.t 
		     | Replicated of Replication.t
		     | Turned of Turning.t
		     | StartFailed of Set.Value.t
		     | Started of CellState.t
end

include CELL.T 

val first : Set.t 
         -> Set.Index.t 
         -> (Event.t -> unit) 
         -> t option

