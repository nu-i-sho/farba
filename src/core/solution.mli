type t

val label : t -> SolutionLabel.t
val command : int -> t -> Command.t
val length : t -> int
val fold : ('a -> Command.t -> 'a) -> 'a -> t -> 'a
val to_array : t -> Command.t array
  
module Loader : sig
    val load : SolutionLabel.t -> t
  end
