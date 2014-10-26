type t = | Filled of Color.t
         | Expect of Color.t
	 | Empty

let empty = Empty

type source_t = char
let parse = function 
  | '_' -> empty
  | oth -> Expect (Color.parse oth)
