module type T = sig
  include INTEROPPOSITION_LINK.T with type key_t = Hand.t

  val load_from value_t Array.t
end

module type MAKE_T = functor
    (Value : EMPTIBLE.T) -> T with type value_t = Value.t
