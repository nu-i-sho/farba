type t

val start    : t
val top      : t -> Data.Crumb.t
val move     : t -> t
val back     : t -> t
val split    : t -> t
val to_array : t -> Data.Crumb.t array
