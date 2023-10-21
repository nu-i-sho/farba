module type T = sig
  type t

  val min  : t
  val max  : t
  val succ : t -> t
  val pred : t -> t
end
