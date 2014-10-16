module type T = sig
  include ORDERABLE_AND_OPPOSABLE.T
  val turn    : t -> ~to':Hand.t -> t
  val default : t
end

module type SEED_T = sig
  type t
  val all_from_default_ordered_to_right : t List.t
end

module type MAKE_T = functor
    (Seed : SEED_T) -> 
      T with type t = Seed.t
