module type T = sig
  include READONLY_LINK.T
  val link : 'a t -> ~to':('a t) -> ~by:key_t -> 'a t
end

module type MAKE_T = functor 
    (Key : ORDERED.T) -> 
      T with type key_t = Key.t
