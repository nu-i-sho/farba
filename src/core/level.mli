type t 

val active : t -> int * int
val height : t -> int
val width  : t -> int
val flora  : t -> Pigment.t Index.Map.t
val fauna  : t -> Nucleus.t Index.Map.t

module Loader : sig
    module Make (Root : LEVELS_SOURCE_TREE.ROOT.T) : sig
        val load : DotsOfDice.t -> DotsOfDice.t -> DotsOfDice.t -> t
      end
  end
