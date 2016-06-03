type t = | Blue 
         | Gray
	 | Red

val opposite : t -> t
val of_hels  : HelsPigment.t -> t
