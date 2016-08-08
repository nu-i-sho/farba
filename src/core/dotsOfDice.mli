type t = Data.DotsOfDice.t
module Map : Map.S with type key = Data.DotsOfDice.t 

val increment : t -> t
val to_string : t -> string
