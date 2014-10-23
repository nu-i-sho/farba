include Imatrix.T with type elt = Cell.t

val parse   : string -> t
val parse_o : string -> observer:((int * int) -> elt -> unit) -> t
