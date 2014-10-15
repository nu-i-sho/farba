type t =  | Color of Color.t
          | Transparent  
let empty = Transparent

type source_t  = char
let parse_from = function 
  | '-' -> Transparent
  | oth -> Color (Color.parse_from oth)
