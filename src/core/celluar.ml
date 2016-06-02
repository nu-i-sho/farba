type t = { cytoplazm : Cytoplazm.t;
	     nucleus : Nucleus.t;
	 }

let turn side x =
  { x with nucleus = Nucleus.turn side x }
