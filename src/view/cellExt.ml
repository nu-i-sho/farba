type t = Data.Cell.t

open Data
open Cell
   
let is_cancer =
  function | { cytoplasm = Pigment.White; _ } -> true
           | { nucleus = n; _ } -> NucleusExt.is_cancer n
