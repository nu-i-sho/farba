type t

val zero      : t
val calculate : t -> Data.Statistics.OfActs.t
val increment : WeaverAct.t -> t -> t
