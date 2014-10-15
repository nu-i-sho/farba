module type T = sig
  type t
  val parse_from : char -> t
end
