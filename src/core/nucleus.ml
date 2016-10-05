open Data.Shared
open Data.Tissue
open Shared.Fail
   
module Pigment = Shared.Pigment
include Shared.Nucleus
   
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

let of_char x =
  {    gaze = Side.of_char x;
    pigment = match x with
              | 'a' .. 'f' -> Gray
              | 'A' .. 'F' -> Blue
              |  _         ->
                  raise (Inlegal_case "Core.Nucleus.of_char")
  }
