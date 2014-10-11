module type T = sig
  include MAKEABLE_READONLY_LINK.T
  val link : 'a t -> ~to':('a t) -> ~by:key_t -> 'a t
end

module type MAKE_T = functor 
    (Key : ORDERABLE.T) -> 
      T with type key_t = Key.t
