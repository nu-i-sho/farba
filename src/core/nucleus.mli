open Data.Shared
open Data.Tissue
   
type t = nucleus

val turn      : hand -> t -> t
val inject    : cytoplasm -> t -> t
val replicate : relation -> t -> t
