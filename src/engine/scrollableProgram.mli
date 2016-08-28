include SCROLLABLE_PROGRAM.T with type line_t = Program.line_t

val resize_up   : int -> t -> t
val resize_down : int -> t -> t
val make        : int -> int
               -> Data.Command.t array
               -> Breadcrumbs.t
               -> t
