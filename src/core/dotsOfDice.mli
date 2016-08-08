type t = Data.DotsOfDice.t 

val increment : t -> t
val to_string : t -> string
val to_int : t -> int
val all : t list

module Map : Map.S with type key = Data.DotsOfDice.t
