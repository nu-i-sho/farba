open Data
type t = Command.t array

let command  = Array.get
let length   = Array.length
let to_array = Array.copy
let of_array = Array.copy
