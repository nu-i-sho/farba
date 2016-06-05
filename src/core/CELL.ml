module type T = sig
    type t
    type rep_res_t

    val turn : HandSide.t -> t -> t

    val replicate : relationship : Relationship.t 
		 -> donor : t
		 -> rep_res_t
  end
