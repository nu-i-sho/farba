type t = | FromLeftToRight of ProgramPoint.t Tools.Vector.t
         | Right of ProgramPoint.t
         | FromRightToLeft of ProgramPoint.t Tools.Vector.t
         | Left of ProgramPoint.t
         | Empty
