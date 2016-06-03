type t = { cytoplazm : Cytoplazm.t;
	     nucleus : Nucleus.t;
	 }

let make nucleus =
  let cytoplazm = 
    nucleus |> Nucleus.pigment_of
            |> Pigment.opposite
            |> Cytoplazm.make
  in

  { cytoplazm; 
    nucleus 
  }

let turn side x =
  let nucleus = 
    x.nucleus |> Nucleus.turn side 
  in
 
  { x with nucleus }

let replicate relationship x = 
  let parent, child = 
    x.nucleus |> Nucleus.replicate relationship
  in

  { x with nucleus = parent }, 
  child
