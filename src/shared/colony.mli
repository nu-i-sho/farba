module Item : sig
    type t = | Cytoplasm of HelsPigment.t
             | Empty

    val to_tissue_item : t -> Item.t   
 
  end

type t

val load   : string list -> t
val read   : string -> t
val width  : t -> int
val height : t -> int
val get    : Index.t -> t -> Item.t 
