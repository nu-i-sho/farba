type t = { program : Command.t list;
           pigment : Pigment.t;
              gaze : HexagonSide.t;
            spirit : Virus.t;
	      mode : LifeMode.t
	 }

let turn side nucleus = 
  let gaze = HexagonSide.turn nucleus.gaze ~to:side in
  { nucleus with gaze }

let replicate relationship x = 
  let gaze = HexagonSide.opposite x.gaze in
  let pigment =
    let open Relationship in
    match relationship with
    | Inverse -> Pigment.opposite x.pigment
    | Direct  -> x.pigment
  in
   
  { x with spirit = []   },
  { x with gaze, pigment }
