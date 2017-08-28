module Make (Key : Map.OrderedType)
                 : MAPEXT.T with type key = Key.t
