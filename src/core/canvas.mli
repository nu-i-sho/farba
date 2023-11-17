open HexMap

type ('cytoplasm, 'nucleus, 'virus) t

val empty            : ('c, 'n, 'v) t

val cytoplasm_opt    : Coord.t -> ('c, 'n, 'v) t -> 'c option
val nucleus_opt      : Coord.t -> ('c, 'n, 'v) t -> 'n option 
val virus_opt        : Coord.t -> ('c, 'n, 'v) t -> 'v option

val cytoplasm        : Coord.t -> ('c, 'n, 'v) t -> 'c
val nucleus          : Coord.t -> ('c, 'n, 'v) t -> 'n 
val virus            : Coord.t -> ('c, 'n, 'v) t -> 'v

val add_cytoplasm    : Coord.t -> 'c -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val add_nucleus      : Coord.t -> 'n -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val add_virus        : Coord.t -> 'v -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t

val remove_cytoplasm : Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val remove_nucleus   : Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t 
val remove_virus     : Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t

val viruses          : ('v -> bool) -> ('c, 'n, 'v) t -> (Coord.t * 'v) list

val resolve          : Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val dissolve         : Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
                 
val is_resolved      : ('c, 'n, 'v) t -> bool
