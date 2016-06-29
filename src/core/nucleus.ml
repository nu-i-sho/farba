type t = Data.Nucleus.t

open Data.Nucleus
module D = Data

let turn hand o =
  { o with gaze = Side.turn hand o.gaze }

let replicate relation cytoplasm o =
  {    gaze = Side.opposite o.gaze;
    pigment = 
      let pigment = 
	match relation with
	| D.Relation.Inverse -> Pigment.opposite o.pigment
	| D.Relation.Direct  -> o.pigment 
      in
  
      if cytoplasm = pigment then
	D.Pigment.White else
	pigment
  }
