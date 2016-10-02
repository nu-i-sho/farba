open Data.Shared
open Data.Tissue

type t = cell

let is_cancer =
  function | { cytoplasm = White; _ } -> true
           | { nucleus = n; _ }       -> Nucleus.is_cancer n
