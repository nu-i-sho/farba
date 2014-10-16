type t = | Cell of Cell.t
         | Empty

let empty = Empty

type source_t = char
let parse_from = function 
  | '.' -> empty
  | oth -> Cell (Cell.parse_from oth)
