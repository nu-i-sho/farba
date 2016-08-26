include CONTRACTS.BREADCRUMBS_OBSERVER.T

val empty     : t
val top       : t -> Data.CallStackPoint.t
val top_index : t -> int
val point     : int -> t -> Data.CallStackPoint.t option
