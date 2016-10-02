open Data.Shared
type t

val origin     : t
val top        : t -> int * Crumb.t
val item       : int -> t -> Crumb.t
val maybe_item : int -> t -> Crumb.t option
val succ       : t -> t
val pred       : t -> t
val split_top  : t -> t
val exists     : int -> int -> t -> bool
