type t = | FromLeftToRight of ProgramPoint.t Tools.Vector.t
         | RightPoint of ProgramPoint.t
         | FromRightToLeft of ProgramPoint.t Tools.Vector.t
         | LeftPoint of ProgramPoint.t
