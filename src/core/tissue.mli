include CORE.TISSUE.T

val load        : Level.t -> t
val clot        : t -> ((int * int) * Data.Side.t) option
val with_fauna  : Data.Nucleus.t Tools.IntPointMap.t -> t -> t
val with_weaver : (int * int) -> t -> t
val with_clot   : (int * int) -> Data.Side.t -> t -> t
