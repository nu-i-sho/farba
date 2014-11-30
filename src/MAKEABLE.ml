module type T = sig
  include T.T
  type source_t
  val make : source_t -> t
end
