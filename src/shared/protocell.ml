type t = {   pigment : Pigment.t;
                gaze : Side.t;
           cytoplasm : Pigment.t option;
         }

let kind_of o =
  match o.pigment, o.cytoplasm with
  | _          , Some Pigment.Red -> CellKind.Clot
  | Pigment.Red, _                -> CellKind.Cancer
  |  _                            -> CellKind.Hels
