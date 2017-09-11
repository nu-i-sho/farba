type t

val height          : t -> int
val width           : t -> int
val in_range        : (int * int) -> t -> bool
val cytoplasm       : (int * int) -> t -> Pigment.t
val nucleus         : (int * int) -> t -> Nucleus.t
val maybe_cytoplasm : (int * int) -> t -> Pigment.t option
val maybe_nucleus   : (int * int) -> t -> Nucleus.t option
val set_nucleus     : (int * int) -> Nucleus.t -> t -> t
val remove_nucleus  : (int * int) -> t -> t
val set_clot        : (int * int) -> t -> t
val clot            : t -> (int * int) option
