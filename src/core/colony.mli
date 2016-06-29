type t

val height : t -> int
val width  : t -> int
val get    : (int * int) -> t -> Pigment.t

val of_string_array : string array -> t
