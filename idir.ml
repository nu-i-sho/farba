module type T = sig
  include Map.OrderedType

  val turn   : t -> Turn.t -> t
  val left   : t -> t
  val right  : t -> t
  val mirror : t -> t
end
