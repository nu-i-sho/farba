type t

val zero      : t
val get       : Data.WeaverActCounter.t -> t -> int
val increment : Data.WeaverActCounter.Field.t -> t -> t
