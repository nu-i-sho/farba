module type T = sig
    type t
    
    val load   : string -> t 
    val width  : t -> int
    val height : t -> int
    val get    : Index.t -> t -> Item.t
    val set    : Index.t -> Item.t -> t -> unit
end
