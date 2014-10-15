module type T = sig
  type t
  type source_t
  val parse_from : source_t -> t
end
