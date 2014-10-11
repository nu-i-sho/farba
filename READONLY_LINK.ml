module type T = sig
  type 'a t
  type key_t

  val make_with : 'a -> t
  val value_of  : t -> 'a
  val go_from   : t -> ~by:key_t -> t

end
