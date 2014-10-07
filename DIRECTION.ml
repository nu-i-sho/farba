module type T = sig
  include ORDERED_AND_OPPOSABLE.T

  val turn : t -> Turn.t -> t
end
