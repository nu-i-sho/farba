module Make (Key : Map.OrderedType)
     : MAPEXT.T with type key = Key.t

module MakeOpt (Key : Map.OrderedType)
     : MAPEXT.T with type key = Key.t option

module ForInt : MAPEXT.T with type key = int
module ForIntPoint : MAPEXT.T with type key = int * int
