module Make (Crumbs : BREADCRUMBS.T) 
              (Cell : TISSUE_CELL.T) : sig
    type t

    type life_moment_t = | Instant of t
                         | End of LifeCounter.t

    val make : program : Program.t 
            -> infected : Cell.t 
            -> breadcrumbs : Crumbs.t 
            -> t

    val tick : t -> life_moment_t
    val run  : t -> LifeCounter.t
  
  end
