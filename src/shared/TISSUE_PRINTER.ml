module type T = sig
    type t

    val print_empty : Index.t -> t -> unit
    val print_cyto  : Index.t -> HelsPigment.t -> t -> unit
    val print_cell  : Index.t -> Protocell.t -> t -> unit
    val print_diff  : Index.t
                   -> previous : Protocell.t
                   ->  current : Protocell.t
                   -> t
                   -> unit
end
