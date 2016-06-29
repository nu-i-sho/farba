module Make (Anatomy : ANATOMY.T) : sig
    type t

    val calculate : Anatomy.t -> t

    val pigmented_cytoplasm : t -> int
    val uncovered_cytoplasm : t -> int

    val cells        : t -> int
    val hels_cells   : t -> int
    val cancer_cells : t -> int

    val has_clot : t -> bool
    val is_outed : t -> bool
    
  end
