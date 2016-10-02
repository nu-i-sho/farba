open Data.Shared
open Data.Tissue
open Utils

type t 

val active : t -> int * int
val height : t -> int
val width  : t -> int
val flora  : t -> cytoplasm IntPointMap.t
val fauna  : t -> nucleus IntPointMap.t
val path   : t -> level_path
  
module Loader : sig
    module Make (Tree : LEVELS.SOURCE_TREE.ROOT.T) : sig
        val load : level_path -> t
      end
  end
