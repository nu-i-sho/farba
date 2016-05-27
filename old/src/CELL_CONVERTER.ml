module type T = CONVERTER.T

module type MAKE_T = 
    functor (Source : T.T) ->
      functor (Color : T.T) -> 
	functor (Cell : CELL.T with type color_t = Color.t) ->
	  functor (CConv : CONVERTER.T  
		     with type source_t = Source.t
		     and type product_t = Color.t) ->
		  
		       T with type source_t = Source.t
                         and type product_t = Cell.t
