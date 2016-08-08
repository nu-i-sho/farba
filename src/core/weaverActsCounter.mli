type t

val zero      : t
val calculate : t -> Data.WeaverActsStatistics.t
val increment : WeaverAct.t -> t -> t
