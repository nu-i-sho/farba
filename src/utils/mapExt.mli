module Make (Key : Map.OrderedType)
     : MAPEXT.T with type key = Key.t

module MakeOpt (Key : Map.OrderedType)
     : MAPEXT.T with type key = Key.t option
