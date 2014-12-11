module Make : CELL_FROM_CHAR_CONVERTER.MAKE_T =
  functor (Color : T.T) -> 
    functor (Cell : CELL.T with type color_t = Color.t) ->
      functor (CConv : FROM_CHAR_CONVERTER.T  
	      with type product_t = Color.t) -> 
  struct
    type t = unit
    type source_t = Color.t
    type product_t = Cell.t

    let cconv = CConv.make ()
    let make () = ()
    let convert = function
      | '-' -> fun () -> Cell.empty
      | oth -> fun () -> Cell.Expect (cconv |> CConv.convert oth)
  end

include Make (Color) (Cell) (ColorFromCharConverter)
