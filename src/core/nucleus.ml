type t = Data.Nucleus.t

open Data.Nucleus
module D = Data

let turn hand o =
  { o with gaze = Side.turn hand o.gaze }

let inject cytoplasm o =
  { o with pigment = if cytoplasm = o.pigment then
		     D.Pigment.None else
		     o.pigment
  }

let replicate relation cytoplasm o =
  {    gaze = Side.opposite o.gaze;
    pigment = match relation with
	      | D.Relation.Inverse -> Pigment.opposite o.pigment
	      | D.Relation.Direct  -> o.pigment 
  } |> inject cytoplasm
