open Data
type t = { command : Command.t;
             crumb : CallStackPoint.t Crumb.Value.t option
         }
