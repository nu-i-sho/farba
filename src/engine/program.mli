type t
   
val make        : int -> Data.Command.t array -> Breadcrumbs.t -> t
val width       : t -> int
val lines_count : t -> int
val crumbs      : t -> Breadcrumbs.t
val with_crumbs : Breadcrumbs.t -> t -> t
val line        : int -> t -> ProgramLine.t
