type t = Data.Action.t

open Data
open Action

let count = 6
let index_of =
  function | Replicate Relation.Direct  -> 0
           | Replicate Relation.Inverse -> 1
           | Turn Hand.Right            -> 2
           | Turn Hand.Left             -> 3
           | Move                       -> 4
           | Pass                       -> 5
