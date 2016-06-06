module type T = sig
    type t

    val state_of  : t -> CellState.t
    val turn      : HandSide.t -> t -> t
    val replicate : relationship : Relationship.t 
                 -> donor : t
                 -> t ReplicationResult.t
  end
