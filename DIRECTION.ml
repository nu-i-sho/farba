module type T = sig
  include ORDERABLE_AND_OPPOSABLE.T
  val turn : t -> ~to':Hand.t -> t
end
