type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

module Map    : Utils.MAPEXT.T with type key = t
module MapOpt : Utils.MAPEXT.T with type key = t option

val count : int
val all : t list
val max : t
val min : t  

val succ : t -> t
val pred : t -> t
