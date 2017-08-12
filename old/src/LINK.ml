module type T = sig
  include MAKEABLE_READONLY_LINK.T
  val link : 'a t -> to':('a t) -> by:key_t -> 'a t
end

module type EXT_T = sig
  type key_t
  type 'a t = { links : (key_t * 'a t) list;
		value : 'a
	      }

  include T with type 'a t := 'a t and type key_t := key_t
end

module type MAKE_EXT_T = functor
    (Key : ORDERABLE.T) -> 
      EXT_T with type key_t = Key.t

module type MAKE_T = functor 
    (Key : ORDERABLE.T) -> 
      T with type key_t = Key.t
