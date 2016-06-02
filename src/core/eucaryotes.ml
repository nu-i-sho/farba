type t = | Nucleus of Nucleus.t
         | Celluar of Celluar.t
	 | Cancer

let turn side = 
  function | Cancer    -> Cancer
           | Nucleus x -> Nucleus (Nucleus.turn side x)
           | Celluar x -> Celluar (Celluar.turn side x)
