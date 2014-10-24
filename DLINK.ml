module type T = sig
  include INTEROPPOSITION_LINK.T with type key_t = Hand.t
  val load : 'a list -> 'a t
end
