module type T = sig
  include READONLY_LINK.T with type key_t = Hand.t
  val close : 'a Dlink.t -> 'a t
end
