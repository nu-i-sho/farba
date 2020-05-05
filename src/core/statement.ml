type ('param, 'loop) t =
  { command : 'param Command.t;
       args : Dots.t Command.t Dots.Map.t;
       loop : 'loop Availability.t option
  }
