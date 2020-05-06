module Loop = struct
  type t = Dots.t option
  end

module Args = struct
  type e = (unit, unit, unit, unit) Statement.t
  type t = e Dots.Map.t option
  end
              
type e = ((* | Perform   of Action.t * *)  Loop.t,
          (* | Call      of Dots.t   * *) (Loop.t * Args.t),
          (* | Parameter of Dots.t   * *) (Loop.t * Args.t),
          (* | Procedure of Dots.t   * *)  unit
         ) Statement.t

type t = e List.t
