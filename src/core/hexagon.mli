module Index : sig
    type t

    val zero : t
    val move : HexagonSide.t -> t ->t
  end

module Value : sig
    type t = | Cytoplazm of HelsPigment.t
             | Celluar of Celluar.t
             | Empty
  end

module rec Element : sig
    type t
    type replication_result_t = 
      | ReplicatedToOutOfWorld
      | Replicated of t
      | SelfCloted of t

    val neighbor  : HexagonSide.t -> t -> t
    val turn      : HexagonSide.t -> t -> t
    val replicate : relationship:Relationship.t
		 -> donor:t
		 -> t

  end and Set : sig
    type t
     
    val width  : t -> int
    val height : t -> int
    val get    : Index.t -> t -> Element.t
    val set    : Index.t -> Value.t -> t -> Element.t
    val read   : string -> t

  end
