open Common

type t =
  { pigment : Pigment.t;
       gaze : Side.t
  }

let make pigment gaze =
  { pigment;
    gaze
  }
  
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
    
