module State : sig
    type t = private { value : Protocell.t;
		       index : Set.Index.t
		     }
  end

module Event : sig

    module Replication : sig
	type t = private { relationship : Relationship.t;
                                 parent : State.t;
                                  child : State.t
			 }
      end

    module SelfClotting : sig
	type t = private { relationship : Relationship.t;
                                previus : State.t;
                                current : State.t
			 }
      end

    module Turning : sig
	type t = private {      side : HandSide.t;
	                   prev_gaze : HexagonSide.t;
		             current : State.t
			 }

      end

    type t = private | ReplicatedOut of Replication.t
		     | SelfClotted of SelfClotting.t 
		     | Replicated of Replication.t
		     | Turned of Turning.t
		     | StartFailed of Set.Value.t
		     | Started of State.t
end

type t

type start_result_t = private | StartFailed of Set.Value.t 
			      | Started of t

type rep_res_t = private | SelfClotted of t
			 | Replicated of t
			 | ReplicatedOut
include CELL.T 
	with type t := t 
         and type rep_res_t := rep_res_t

val start : level:Set.t 
         -> start:Set.Index.t 
         -> start_result_t

val starto : level:Set.t
          -> start:Set.Index.t
          -> observer:(Event.t -> unit)
	  -> start_result_t

val state_of : t -> State.t
