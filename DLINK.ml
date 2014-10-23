module type T = sig
  include INTEROPPOSITION_LINK.T with type key_t = Hand.t
  val load_from : 'a list
end
