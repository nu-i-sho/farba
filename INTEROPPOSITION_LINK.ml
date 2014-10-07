module type T = sig
  include READONLY_LINK.T

  val join : t -> ~with':t -> ~by:key_t -> t
end

module type MAKE_T = 
    functor (Key : ORDERED_AND_OPPOSABLE.T)(Value : EMPTIBLE.T) -> 
      T with type key_t = Key.t and value_t = Value.t
