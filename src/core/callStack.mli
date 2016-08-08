type t

val start : t
val top : t -> Data.CallStackPoint.t
val increment : t -> t
val decrement : t -> t
val split : t -> t
