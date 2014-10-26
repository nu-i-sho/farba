module type T = sig
  include ORDERABLE_AND_OPPOSABLE.T
  val turn    : t -> to':Hand.t -> t
  val default : t
end

module type MAKE_T = functor
    (Seed : DIRECTION_SEED.T) -> 
      T with type t = Seed.t
