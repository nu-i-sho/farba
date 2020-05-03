type 'param t =
  | Do of Action.t
  | Call of Dots.t
  | Procedure of Dots.t
  | Parameter of 'param
