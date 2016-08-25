type t 

val active : t -> int * int
val height : t -> int
val width  : t -> int
val flora  : t -> Data.Pigment.t Tools.IntPointMap.t
val fauna  : t -> Data.Nucleus.t Tools.IntPointMap.t
val path   : t -> LevelPath.t
  
module Loader : sig
    module Make (Tree : CONTRACTS.LEVELS_SOURCE_TREE.ROOT.T) : sig
        val load : LevelPath.t -> t
      end
  end
