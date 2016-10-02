open Data.Shared
open Data.Tissue

type t = nucleus

let is_cancer o =
  match o.pigment with
  | Blue | Gray -> false
  | White       -> true
