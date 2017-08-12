type t

val label    : t -> SolutionLabel.t
val command  : int -> t -> Data.Command.t
val length   : t -> int
val fold     : ('a -> Data.Command.t -> 'a) -> 'a -> t -> 'a
val to_array : t -> Data.Command.t array
  
module Loader : sig
    val load : SolutionLabel.t -> t
  end
