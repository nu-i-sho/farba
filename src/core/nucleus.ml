type t = Data.Nucleus.t

open Data.Nucleus

let turn hand o =
  { o with gaze = Side.turn hand o.gaze }

let inject cytoplasm o =
  { o with pigment = if cytoplasm = o.pigment then
		     Data.Pigment.None else
		     o.pigment
  }

let replicate relation cytoplasm o =
  {    gaze = Side.opposite o.gaze;
    pigment = let open Data.Relation in
              match relation with
	      | Inverse -> Pigment.opposite o.pigment
	      | Direct  -> o.pigment 
  } |> inject cytoplasm
