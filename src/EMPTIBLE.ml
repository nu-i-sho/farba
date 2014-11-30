module type T = sig
  include T.T
  val empty : t
end
