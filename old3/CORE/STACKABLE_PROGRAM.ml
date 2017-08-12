module type T = sig
    include FOCUSED_PROGRAM.T
            with type focus_line_t = StackableProgramLine.t 
    include SCROLLABLE.T
            with type t := t
  end
