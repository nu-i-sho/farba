include FOCUSED_PROGRAM.T
        with type focus_line_t = Data.ProgramLine.t
         and type focus_active_line_t =
                    (int * Data.ProgramActiveLine.t) option
include SCROLLABLE.T
        with type t := t
