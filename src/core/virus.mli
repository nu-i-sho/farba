module Make (Crumbs : BREADCRUMBS.T) 
              (Cell : TISSUE_CELL.T) : sig
    type t

    val make : program : Program.t 
            -> infected : Cell.t 
            -> breadcrumbs : Crumbs.t 
            -> t

    val next : t -> t option
    val run  : t -> unit
  
  end
