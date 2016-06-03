type t

val make          : Set.t -> t 
val value_of      : t -> Flesh.t option
val neighbor_from : HexagonSide.t -> t -> t

val set_value     : Flesh.t option -> t -> t
