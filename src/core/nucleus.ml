open Data.Shared
open Data.Tissue

module Pigment = Proto.Pigment   

type t = nucleus

let turn hand o =
  { o with gaze = Side.turn hand o.gaze
  }

let inject cytoplasm o =
  { o with pigment = if cytoplasm = o.pigment then
		       White else
		       o.pigment
  }

let replicate relation o =
  {    gaze = Side.opposite o.gaze;
    pigment = match relation with
	      | Inverse -> Pigment.opposite o.pigment
	      | Direct  -> o.pigment 
  }
