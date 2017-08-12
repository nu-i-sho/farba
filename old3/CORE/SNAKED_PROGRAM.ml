open Data

module type T = sig
    include PROGRAM.T
        
    val width       : t -> int
    val height      : t -> int
    val active_line : t -> ProgramActiveLine.t 
    val maybe_line  : int -> t -> ProgramLine.t option
    val line        : int -> t -> ProgramLine.t
      
  end
