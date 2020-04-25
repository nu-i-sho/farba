module type REVERSIBLE = sig
  type t
  val reverse : t -> t
  end

module type SEQUENTIAL = sig
  type t
  val succ : t -> t
  val pred : t -> t
  end
