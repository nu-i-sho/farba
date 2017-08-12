type t = string array

let load    = Array.of_list
let height  = Array.length
let width o = 
  o |> Array.get 0
    |> String.length

let get (x, y) o = 
  o |> Array.get y
    |> String.get x
    |> ColonyItem.of_char

let mem (x, y) o = 
  x >= 0         && 
  y >= 0         && 
  x < (width  o) &&
  y < (height o)
