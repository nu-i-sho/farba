type t = unit
type source_t = char
type product_t = Color.t

let make () = ()
let convert chr () =
  match chr with
  | '1' -> Red
  | '2' -> Orange
  | '3' -> Yellow
  | '4' -> Green
  | '5' -> Blue
  | '6' -> Violet
