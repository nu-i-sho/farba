type t = | White
         | Blue
         | Gray
         | None

val opposite : t -> t
val of_char  : char -> t
