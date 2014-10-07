module type T = sig

  include EMPTIBLE.T

  type key_t
  type value_t

  val make_with : value_t -> t
  val value_of  : t -> value_t
  val go_from   : t -> ~by:key_t -> t

end
