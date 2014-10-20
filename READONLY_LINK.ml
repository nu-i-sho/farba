module type T = sig
  type 'a t
  type key_t

  val value_of       : 'a t -> 'a
  val get_from       : 'a t -> by:key_t -> 'a t
  val is_impasse     : 'a t -> by:key_t -> bool
  val go_from        : 'a t -> by:key_t -> steps_count:int -> 'a t
  val go_to_end_from : 'a t -> by:key_t -> 'a t
end
