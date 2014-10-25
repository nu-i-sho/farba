module type T = sig
  include MAKEABLE_READONLY_LINK.T
  val link : 'a t -> to':('a t) -> by:key_t -> 'a t
end

module type MAKE_EXT_T = functor
    (Key : ORDERABLE.T) -> functor
      (Links : Map.S with type key = Key.t) -> sig
	type 'a t = { links : 'a t Links.t;
		      value : 'a
		    }

	include T with type 'a t := 'a t and type key_t = Key.t
      end

module type MAKE_T = functor 
    (Key : ORDERABLE.T) -> 
      T with type key_t = Key.t
