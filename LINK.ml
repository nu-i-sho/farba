module type T = sig
  include READONLY_LINK.T

  val link : t -> ~to':t -> ~by:key_t -> t
end

module type MAKE_T = functor 
    (Key : ORDERED.T) 
      (Value : EMPTIBLE.T) 

  -> T with type key_t = Key.t and value_t = Value.t
    
