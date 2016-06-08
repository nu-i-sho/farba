module Index : sig
    type t

    val zero : t
    val move : Side.t -> t -> t 
  end

module Item : sig
    type t = | Cytoplasm of HelsPigment.t
             | Cell of Protocell.t
             | Empty
             | Out
  end

module Set : sig 
    type t
     
    val width  : t -> int
    val height : t -> int
    val get    : Index.t -> t -> Item.t
    val set    : Index.t -> Item.t -> t -> unit
    val read   : string -> t
  end
