open Data.Shared
open Data.Tissue
open Utils
open LEVEL

type t 

val active : t -> int * int
val height : t -> int
val width  : t -> int
val flora  : t -> cytoplasm IntPointMap.t
val fauna  : t -> nucleus IntPointMap.t
val path   : t -> level_path
  
module MakeLoader (Tree : SOURCE_TREE.ROOT.T) : sig
    val load : level_path -> t
  end
