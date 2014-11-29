module type T = sig
  type t
  type source_t
  val make : source_t -> t
end
