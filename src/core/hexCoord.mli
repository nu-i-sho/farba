type t

val zero    : t
val compare : t -> t -> int
val move    : Side.t -> t -> t
