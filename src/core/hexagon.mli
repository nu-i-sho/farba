type t

val make        : Set.t -> t 
val value_of    : t -> DNA.t option
val neighbor_of : t -> from:HexagonSide.t -> t
