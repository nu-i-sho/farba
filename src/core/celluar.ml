type t = { cytoplazm : Cytoplazm.t;
	     nucleus : Nucleus.t;
	 }

let turn side x =
  { x with nucleus = Nucleus.turn side x }

let replicate relationship x = 
  let parent_nacleus, child = 
    Nucleus.replicate relationship x.nacleus
  in

  { x with nucleus = parent_nacleus },
  child

