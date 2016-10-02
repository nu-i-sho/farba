open Data.Tissue
open Utils

include CORE.TISSUE.T

val load        : Level.t -> t
val clot        : t -> ((int * int) * clot) option
val with_fauna  : nucleus IntPointMap.t -> t -> t
val with_weaver : (int * int) -> t -> t
val with_clot   : (int * int) -> clot -> t -> t
