type t =
  | Cross
  | Triplet
  | Line
  | Dot

let origin = Cross  
let succ   = function
  | Cross   -> Triplet
  | Triplet -> Line
  | Line    -> Dot
  | Dot     -> Cross
