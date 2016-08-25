type t

val load        : Level.t -> t
val height      : t -> int
val width       : t -> int
val init_items  : t -> Data.TissueItemInit.t Tools.Matrix.t
val items       : t -> TissueItem.t Tools.Matrix.t
val fauna       : t -> Data.Nucleus.t Tools.IntPointMap.t
val flora       : t -> Data.Pigment.t Tools.IntPointMap.t
val weaver      : t -> (int * int)
val clot        : t -> ((int * int) * Data.Side.t) option
val with_fauna  : Data.Nucleus.t Tools.IntPointMap.t -> t -> t
val with_weaver : (int * int) -> t -> t
val with_clot   : (int * int) -> Data.Side.t -> t -> t
