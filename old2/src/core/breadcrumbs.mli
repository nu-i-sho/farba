type t

val start  : t
val top    : t -> int * (Data.DotsOfDice.t Data.Doubleable.t)
val get    : int -> t -> Data.DotsOfDice.t Data.Doubleable.t
val move   : t -> t
val back   : t -> t
val split  : t -> t
val exists : int -> int -> t -> bool
