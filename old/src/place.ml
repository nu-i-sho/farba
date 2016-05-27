module Make : EMPTIBLE_AND_CHAR_PARSABLE.MAKE_T = functor
  (Cell : FROM_CHAR_MAKEABLE.T) -> struct
    
    type t = | Cell of Cell.t
             | Empty

    let empty = Empty

    type source_t = char
    let make = function 
      | '.' -> empty
      | oth -> Cell (Cell.make oth)
  end
