type t = { program : Command.t list;
           pigment : Pigment.t;
              gaze : HexagonSide.t;
            spirit : Virus.t option;
	      mode : LifeMode.t
	 }

let pigment_of x = 
  x.pigment

let turn side nucleus = 
  let gaze =  nucleus.gaze |> HexagonSide.turn side in
  { nucleus with gaze }

let replicate relationship x = 
  let gaze = HexagonSide.opposite x.gaze in
  let pigment =
    let open Relationship in
    match relationship with
    | Inverse -> Pigment.opposite x.pigment
    | Direct  -> x.pigment
  in
   
  { x with spirit = None },
  { x with gaze; pigment }
