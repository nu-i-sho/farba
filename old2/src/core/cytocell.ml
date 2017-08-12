include Shared.Cytocell.t

let turn side o = 
  { o with nucleus = Nucleus.turn side o.nucleus }

let replicate relation o = 
  Nucleus.replicate relation o.nucleus
