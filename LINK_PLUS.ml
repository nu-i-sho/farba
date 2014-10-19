module type T = sig
  type 'a t
  type key_t

  val go_to_end_from : 'a t -> by:key_t
  val go_from        : 'a t -> by:key_t -> ~steps_count:int
end
