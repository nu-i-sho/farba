module type T = sig
  include MAKEABLE.T
  val set_make : (source_t * t) -> unit
end

module type MAKE_T = functor
    (Product : T.T) -> functor
      (Source : T.T) -> 
	T with type t = Product.t and type source_t = Source.t
