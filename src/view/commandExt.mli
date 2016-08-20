type t = Data.Command.t

val kind_of  : t -> CommandKind.t
val index_of : t -> int
val compare  : t -> t -> int
