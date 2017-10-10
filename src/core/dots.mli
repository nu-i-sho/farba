type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

include Utils.SEQUENTIAL.T with type t := t
include Map.OrderedType with type t := t 

module Map    : Utils.MAPEXT.T with type key = t
module MapOpt : Utils.MAPEXT.T with type key = t option
      
val to_int : t -> int
val of_int : int -> t
val count  : int
val max    : t
val min    : t
val all    : t list
