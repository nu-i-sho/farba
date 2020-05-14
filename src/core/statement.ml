type t =
  | Perform of Action.t
  | Call    of Dots.t
  | Declare of Dots.t
