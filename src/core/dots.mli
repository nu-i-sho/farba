type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

module Map    : Utils.MAPEXT.T with type key = t
module MapOpt : Utils.MAPEXT.T with type key = t option

include Sig.SEQUENTIAL with type t := t
     
val count : int

val all : t list
val max : t
val min : t
