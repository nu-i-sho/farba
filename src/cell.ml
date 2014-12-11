module Make : CELL.MAKE_T = functor (Color : T.T) -> struct
  include CellState with type color_t = Color.t
  let empty = Empty
end

include Make (Color)
