type t = 
  { pigment : Pigment.t;
       gaze : Side.p
  }

let make pigment gaze =
  { pigment;
    gaze
  }

let of_chars a b =
  make (Pigment.of_char a)
       (Side.of_char b)

let pigment_of o = o.pigment
let gaze_of    o = o.gaze
              
let is_cancer o =
  match pigment_of o with
  | Blue | Gray -> false
  | White       -> true

let turn direction o =
  { o with gaze = 
    (gaze_of o) |> Side.turn direction 
  }

let inject cytoplasm o =
  let pigment = pigment_of o in
  let pigment = match pigment, cytoplasm with
    | White, _   | _, White 
    | Blue, Gray | Gray, Blue -> pigment
    | Blue, Blue | Gray, Gray -> White 
  in
  { o with pigment
  }

let replicate relation o =
  let gaze = Side.opposite (gaze_of o)
  and pigment = match relation with
    | Inverse -> Pigment.opposite (pigment_of o)
	| Direct  -> pigment_of o 
  in
  { pigment;
    gaze
  }
