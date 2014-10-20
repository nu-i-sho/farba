module type T = sig
  type 'a t
  type key_t

  val go_to_end_from : 'a t -> by:key_t
  val go_from        : 'a t -> by:key_t -> steps_count:int
end

module type MAKE_T = functor
  (Base : READONLY_LINK.T) ->
    T with type 'a t = 'a Base.t and key_t = Base.key_t 
