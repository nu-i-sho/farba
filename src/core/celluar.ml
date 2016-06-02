type t = { cytoplazm : Cytoplazm.t;
	     nucleus : Nucleus.t;
	 }

let make nucleus =
  let cytoplazm = 
    nucleus |> Nucleus.pigment_of
            |> Pigment.opposie
  in

  { cytoplazm; 
    nucleus 
  }

let turn side x =
  { x with nucleus = Nucleus.turn side x }

let replicate relationship x = 
  let parent_nacleus, child = 
    Nucleus.replicate relationship x.nacleus
  in

  { x with nucleus = parent_nacleus },
  child

