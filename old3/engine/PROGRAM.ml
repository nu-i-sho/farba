module type T = sig
    type line_t
    type t
     
    val width       : t -> int
    val lines_count : t -> int
    val crumbs      : t -> Breadcrumbs.t
    val with_crumbs : Breadcrumbs.t -> t -> t
    val line        : int -> t -> (int * (line_t option))
  end
