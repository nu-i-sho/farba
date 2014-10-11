module type T = sig
  type 'a t
  type key_t

  val value_of  : t -> 'a
  val go_from   : t -> ~by:key_t -> t
  val is_impasse : 'a t -> by:key_t -> bool
end
