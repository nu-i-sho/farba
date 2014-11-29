module Make : EMPTIBLE_AND_FROM_CHAR_MAKEABLE.MAKE_T = functor
  (Color : FROM_CHAR_MAKEABLE.T) -> struct

    type t = | Filled of Color.t
             | Expect of Color.t
	     | Empty

    let empty = Empty

    type source_t = char
    let make = function 
      | '-' -> empty
      | oth -> Expect (Color.make oth)
  end
