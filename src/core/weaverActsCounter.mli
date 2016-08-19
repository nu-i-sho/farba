type t

val zero      : t
val calculate : t -> Data.ActsStatistics.t
val increment : WeaverAct.t -> t -> t
