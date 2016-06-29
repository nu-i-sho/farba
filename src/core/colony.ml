type t = string array

let height = Array.length
let width o = String.length o.(0)
let get (x, y) o = Pigment.of_char o.(y).[x]
let of_string_array o = o
