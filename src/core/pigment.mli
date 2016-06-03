type t = | Blue 
         | Gray
	 | Red

val opposite : t -> t
val to_char  : t -> char
val of_char  : char -> t
