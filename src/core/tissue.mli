type t

val load        : Level.t -> t
val height      : t -> int
val width       : t -> int
val items       : t -> Data.TissueItem.t Matrix.t
val fauna       : t -> Data.Nucleus.t Index.Map.t
val flora       : t -> Data.Pigment.t Index.Map.t
val weaver      : t -> (int * int)
val clot        : t -> ((int * int) * Data.Side.t) option
val with_fauna  : Data.Nucleus.t Index.Map.t -> t -> t
val with_weaver : (int * int) -> t -> t
val with_clot   : (int * int) -> Data.Side.t -> t -> t
