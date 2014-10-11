module type T = sig
  include MAKEABLE_READONLY_LINK.T
  val join : 'a t -> ~with':('a t) -> ~by:key_t -> 'a t
end

module type MAKE_T = functor 
    (Key : ORDERABLE_AND_OPPOSABLE.T) -> 
      T with type key_t = Key.t
