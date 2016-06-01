type t

val make          : Set.t -> t 
val value_of      : t -> DNA.t option
val neighbor_from : HexagonSide.t -> t -> t

val set_value     : DNA.t option -> t -> t
