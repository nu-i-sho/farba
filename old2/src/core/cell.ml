include Shared.Cell

let turn side =
  function | Nucleus  n -> Nucleus (Nucleus.turn side n)
           | Cytocell c -> Cytocell (Cytocell.turn side c)  

let replicate relation o =  
  let Nucleus n | Cytocell { nucleus = n, _ }) = o
  Nucleus.replicate relation n
