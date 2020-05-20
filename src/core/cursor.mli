module Make : functor (Tissue : module type of Tissue) ->
              CURSOR.S with type tissue := Tissue.t
                        and type coord  := Tissue.Coord.t
