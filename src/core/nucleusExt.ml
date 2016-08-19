type t = Data.Nucleus.t

open Data
open Nucleus

let turn hand o =
  { o with gaze = SideExt.turn hand o.gaze }

let inject cytoplasm o =
  { o with pigment = if cytoplasm = o.pigment then
		       Pigment.White else
		       o.pigment
  }

let replicate relation o =
  {    gaze = SideExt.opposite o.gaze;
    pigment = match relation with
	      | Relation.Inverse -> Pigment.opposite o.pigment
	      | Relation.Direct  -> o.pigment 
  }
