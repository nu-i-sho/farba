type t

val load        : Level.t -> t
val height      : t -> int
val width       : t -> int
val items       : t -> Data.TissueItem.t Matrix.t
val fauna       : t -> Nucleus.t Index.Map.t
val flora       : t -> Pigment.t Index.Map.t
val weaver      : t -> (int * int)
val clot        : t -> ((int * int) * Side.t) option
val with_fauna  : Nucleus.t Index.Map.t -> t -> t
val with_weaver : (int * int) -> t -> t
val with_clot   : (int * int) -> Side.t -> t -> t
