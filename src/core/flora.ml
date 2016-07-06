type e = Pigment.t
type t = e array array

let load src =
  let width = String.length src.(0)
  and item row x = Pigment.of_char row.[x] in
  let row y = Array.init width (item src.(y)) in
  Array.init (Array.length src) row

let height  = Array.length
let width o = Array.length o.(0)

let get (x, y) o =
  o.(y).(x)
