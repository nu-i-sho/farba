module Value = struct
    type t = | FromLeftToRight of ProgramItem.t Std.Vector.t
             | Right of ProgramItem.t
             | FromRightToLeft of ProgramItem.t Std.Vector.t
             | Left of ProgramItem.t
  end

type t = {  is_active : bool;
           has_crumbs : bool;
                index : int;
                value : Value.t
         }
