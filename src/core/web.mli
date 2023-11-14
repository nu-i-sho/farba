type ('cytoplasm, 'nucleus, 'virus) t

val empty            : ('c, 'n, 'v) t

val cytoplasm_opt    : HexMap.Coord.t -> ('c, 'n, 'v) t -> 'c option
val nucleus_opt      : HexMap.Coord.t -> ('c, 'n, 'v) t -> 'n option 
val virus_opt        : HexMap.Coord.t -> ('c, 'n, 'v) t -> 'v option

val cytoplasm        : HexMap.Coord.t -> ('c, 'n, 'v) t -> 'c
val nucleus          : HexMap.Coord.t -> ('c, 'n, 'v) t -> 'n 
val virus            : HexMap.Coord.t -> ('c, 'n, 'v) t -> 'v

val add_cytoplasm    : HexMap.Coord.t -> 'c -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val add_nucleus      : HexMap.Coord.t -> 'n -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val add_virus        : HexMap.Coord.t -> 'v -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t

val remove_cytoplasm : HexMap.Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val remove_nucleus   : HexMap.Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t 
val remove_virus     : HexMap.Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t

val resolve          : HexMap.Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val dissolve         : HexMap.Coord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
                 
val is_resolved      : ('c, 'n, 'v) t -> bool

