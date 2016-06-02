type t = { cytoplazm : Cytoplazm.t;
	     nucleus : Nucleus.t;
	 }

let make ~cytoplazm:c ~nucleus:n =
  { cytoplazm = c;
      nucleus = n
  }

let turn side x =
  { x with nucleus = Nucleus.turn side x }

let replicate relationship x = 
  let parent_nacleus, child = 
    Nucleus.replicate relationship x.nacleus
  in

  { x with nucleus = parent_nacleus },
  child

