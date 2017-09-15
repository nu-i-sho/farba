open Common

type t = nucleus
let make pigment gaze =
  { pigment;
    gaze
  }

let of_chars c1 c2 =
  make (Pigment.of_char c1)
       (Side.of_char c2)

let pigment o = o.pigment
let gaze    o = o.gaze
              
let is_cancer o =
  match o.pigment with
  | Blue | Gray -> false
  | White       -> true

let turn hand o =
  { o with
    gaze = Side.turn hand o.gaze
  }

let inject cytoplasm o =
  { o with pigment = match o.pigment, cytoplasm with
                     | White, _   | _, White
                     | Blue, Gray | Gray, Blue -> o.pigment
                     | Blue, Blue | Gray, Gray -> White
  }

let replicate relation o =
  {    gaze = Side.opposite o.gaze;
    pigment = match relation with
	      | Inverse -> Pigment.opposite o.pigment
	      | Direct  -> o.pigment 
  }
    
