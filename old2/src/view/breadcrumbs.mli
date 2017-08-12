module Make (Crumbs : BREADCRUMBS.T) 
            (Canvas : CANVAS.T)
           (Pointer : PROGRAM_POINTER.T)
           (DotsImg : IMG.DOTS_OF_DICE.T) : sig
 
    include BREADCRUMBS.T
    val make : breadcrumbs : Crumbs.t 
            -> pointer : Pointer.t 
            -> t
  end
