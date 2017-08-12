module type T = sig
  include T.T
  val opposite : t -> t
end
