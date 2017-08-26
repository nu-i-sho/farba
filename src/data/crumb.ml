open Utils
open Data.Common

type move_mode =
  | Find
  | Call
  | Back
  | Stay

type energy =
  { generation : Dots.t;
          mode : move_mode;
  }

type arg =
  { command : command;
      param : Dots.t;
       mode : move_mode;
  }

type loop =
  | Active of Dots.t * Dots.t
  | Inactive of Dots.t

type t =
  | Energy of energy
  | Arg of arg
  | Loop of loop
