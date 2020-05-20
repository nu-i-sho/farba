type t =
  | Perform of Command.t
  | Call    of Dots.t
  | Declare of Dots.t
