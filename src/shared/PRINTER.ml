module type T = sig
    type t

    val print_empty : (int * int) -> t -> unit
    val print_cyto  : (int * int) -> HelsPigment.t -> t -> unit
    val print_cell  : (int * int) -> Protocell.t -> t -> unit
    val print_diff  : (int * int)
                   -> previous : Protocell.t
                   ->  current : Protocell.t
                   -> t
                   -> unit
end
