module type T = sig
    type t

    val move      : t -> t
    val turn      : Hand.t -> t -> t
    val replicate : Relationship.t -> t -> t
  
  end
