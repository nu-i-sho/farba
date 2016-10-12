module Make (Key : Map.OrderedType)
                 : MAP_EXT.T with type key = Key.t
