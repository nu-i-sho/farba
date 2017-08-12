include SCROLLABLE_PROGRAM.T
        with type line_t = StackableProgramLine.t  

val make : int -> int
        -> Data.Command.t array
        -> Breadcrumbs.t
        -> t
