type t = | Nucleus of Nucleus.t
         | Celluar of Celluar.t
	 | Cancer

let turn side = 
  function | Cancer    -> Cancer
           | Nucleus x -> Nucleus (Nucleus.turn side x)
           | Celluar x -> Celluar (Celluar.turn side x)

let replicate relationship x = 
  match x with
  | Cancer    -> (Cancer), 
		 (Cancer)

  | Nucleus x -> let parent, child = 
		   Nucleus.replicate relationship x 
		 in

		 (Nucleus parent), 
		 (Nucleus child)

  | Celluar x -> let parent, child = 
		   Celluar.replicate relationship x 
		 in

		 (Celluar parent), 
		 (Nucleus child)
