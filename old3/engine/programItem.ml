type t = | FromLeftToRight of ProgramLine.t
         | Right of ProgramPoint.t
         | FromRightToLeft of ProgramLine.t
         | Left of ProgramPoint.t
