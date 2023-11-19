type ('cytoplasm, 'nucleus, 'virus) t

val empty            : ('c, 'n, 'v) t

val cytoplasm_opt    : HexCoord.t -> ('c, 'n, 'v) t -> 'c option
val nucleus_opt      : HexCoord.t -> ('c, 'n, 'v) t -> 'n option 
val virus_opt        : HexCoord.t -> ('c, 'n, 'v) t -> 'v option

val cytoplasm        : HexCoord.t -> ('c, 'n, 'v) t -> 'c
val nucleus          : HexCoord.t -> ('c, 'n, 'v) t -> 'n 
val virus            : HexCoord.t -> ('c, 'n, 'v) t -> 'v

val add_cytoplasm    : HexCoord.t -> 'c -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val add_nucleus      : HexCoord.t -> 'n -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val add_virus        : HexCoord.t -> 'v -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t

val remove_cytoplasm : HexCoord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val remove_nucleus   : HexCoord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t 
val remove_virus     : HexCoord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t

val viruses          : ('v -> bool) -> ('c, 'n, 'v) t -> (HexCoord.t * 'v) list

val resolve          : HexCoord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
val dissolve         : HexCoord.t -> ('c, 'n, 'v) t -> ('c, 'n, 'v) t
                 
val is_resolved      : ('c, 'n, 'v) t -> bool
