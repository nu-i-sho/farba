type t =
  | Declare of declaration
  | Do of { action : action;
             count : Dots.t
          }

 and declaration =
  | Procedure of Dots.t
  | Parameter of Dots.t

 and action =
  | Command of Command.t
  | Call of { procedure : Dots.t;
              arguments : t Dots.Map.t
            }
