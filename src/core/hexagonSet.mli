module Index : sig
    type t

    let zero : t
    let move : HexagonSide.t -> t -> t
  end
		 
type element_t = Flesh.t option
type t

val get  : Index.t -> t -> element_t
val set  : Index.t -> element_t -> t -> unit
val read : string -> t
