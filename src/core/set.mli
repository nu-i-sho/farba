module Index : sig
    type t

    val zero : t
    val move : HexagonSide.t -> t ->t
  end

module Value : sig
    type t = | Cytoplazm of HelsPigment.t
             | Celluar of Celluar.t
             | Empty
  end

type t
     
val width  : t -> int
val height : t -> int
val get    : Index.t -> t -> Value.t
val set    : Index.t -> Value.t -> t -> unit
val read   : string -> t

val is_in_range : Index.t -> t -> bool
val is_out_of_range : Index.t -> t -> bool

