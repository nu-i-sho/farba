module type T = sig
    type t
    type replication_result_t

    val turn : HandSide.t -> t -> t

    val replicate : relationship : Relationship.t 
		 -> donor : t
		 -> replication_result_t
  end
