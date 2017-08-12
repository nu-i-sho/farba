module type T = sig
  type t
  type source_t
  val parse : source_t -> t
end
