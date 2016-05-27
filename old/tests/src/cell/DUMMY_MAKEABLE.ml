module type SETUP_T = sig
  type source_t
  type product_t
  val value : (source_t * product_t) list
end

module type MAKE_T = 
    functor (Source : T.T) -> 
      functor (Product : T.T) -> 
	functor (Setup : SETUP_T with type product_t := Product.t 
	                          and type source_t := Source.t) ->
 
	  MAKEABLE.T with type t = Product.t 
	              and type source_t = Source.t
		
