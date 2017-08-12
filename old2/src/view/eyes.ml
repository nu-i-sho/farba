type t = | Hels of Side.t
         | Cancer of Side.t
         | Clot of Side.t
         | Cytoplasm

let of_cell c =
  match Protocell.kind_of c with
  | CellKind.Hels   -> Hels c.gaze
  | CellKind.Clot   -> Clot c.gaze
  | CellKind.Cancer -> Cancer c.gaze

