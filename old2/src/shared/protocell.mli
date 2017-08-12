type t = {   pigment : Pigment.t;
                gaze : Side.t;
           cytoplasm : Pigment.t option;
         }

val kind_of : t -> CellKind.t
