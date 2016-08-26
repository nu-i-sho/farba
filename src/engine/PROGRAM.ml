module type T = sig
    type t
     
    val width       : t -> int
    val lines_count : t -> int
    val crumbs      : t -> Breadcrumbs.t
    val with_crumbs : Breadcrumbs.t -> t -> t
    val line        : int -> t -> ProgramLine.t
  end
