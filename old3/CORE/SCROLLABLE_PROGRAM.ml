module type T = sig
    include FOCUSED_PROGRAM.T
            with type focused_line_t = ProgramLine.t 
    include SCROLLABLE.T
            with type t := t
  end
