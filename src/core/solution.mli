type t

val label : t -> SolutionLabel.t
val command : int -> t -> Command.t
val length : t -> int

module Loader : sig
    val load : SolutionLabel.t -> t
  end
