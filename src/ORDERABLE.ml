module type T = sig
  include T.T 
  val compare : t -> t -> int
end
