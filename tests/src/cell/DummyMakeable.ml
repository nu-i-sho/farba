module Make : DUMMY_MAKEABLE.MAKE_T = 
  functor (Source : T.T) -> 
    functor (Product : T.T) -> 
      functor (Setup : DUMMY_MAKEABLE.SETUP_T with type product_t := Product.t
	                                       and type source_t := Source.t) ->
  struct
    type t = Product.t
    type source_t = Source.t		 
    let make s = List.assoc s Setup.value
  end
