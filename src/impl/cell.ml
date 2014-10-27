module Make : CELL.MAKE_T = functor
  (Color : FROM_CHAR_MAKEABLE.T) -> struct

    type t = | Filled of Color.t
             | Expect of Color.t
	     | Empty

    let empty = Empty

    type source_t = char
    let make = function 
      | '_' -> empty
      | oth -> Expect (Color.make oth)
  end
