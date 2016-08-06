type t = int * int
module Map : Map.S with type key = t
val move : Side.t -> t -> t 
