module type T = FROM_CHAR_CONVERTER.T

module type MAKE_T = 
    functor (Color : T.T) -> 
      functor (Cell : CELL.T with type color_t = Color.t) ->
	functor (CConv : COLOR_FROM_CHAR_CONVERTER.T  
		with type product_t = Color.t) ->
		  
		  T with type product_t = Cell.t
