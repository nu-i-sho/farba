include PROGRAM.T
      
val make : int -> int -> Data.Command.t array -> Breadcrumbs.t -> t

val view_lines_count : t -> int
val view_line : int -> t -> ProgramLine.t
val up : t -> t
val down : t -> t
