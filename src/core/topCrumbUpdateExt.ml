type t = Data.TopCrumbUpdate.t

open Data
open Crumb
open Doubleable
open TopCrumbUpdate
   
let of_change previous current =
  match previous, current with
  | { value = Single _; _ },
    { value = Single _; _ } -> Moved   (previous, current)
  | { value = Double _; _ },
    { value = Single _; _ } -> Merged  (previous, current)
  | { value = Single _; _ },
    { value = Double _; _ } -> Splited (previous, current)
  | { value = Double _; _ },
    { value = Double _; _ } -> failwith Fail.impossible_case 
