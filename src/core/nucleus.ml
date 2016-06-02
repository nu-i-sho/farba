type t = { program : Command.t list;
           pigment : Pigment.t;
              gaze : HexagonSide.t;
            spirit : Virus.t;
	      mode : LifeMode.t
	 }

let turn side nucleus = 
  let gaze = HexagonSide.turn nucleus.gaze ~to:side in
  { nucleus with gaze }
