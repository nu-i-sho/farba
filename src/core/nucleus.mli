open Data.Shared
open Data.Tissue
   
include module type of Shared.Nucleus

val turn      : hand -> t -> t
val inject    : cytoplasm -> t -> t
val replicate : relation -> t -> t
