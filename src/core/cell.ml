type t = Protocell.t

open Protocell

let first = {   pigment = Pigment.Blue;
                   gaze = Side.Up;
              cytoplasm = None;
	    }

let kind_of = kind_of

let turn side o =
  { o with gaze = Side.turn side o.gaze }

let replicate relation o =
  { o with gaze = Side.opposite o.gaze;
        pigment = let open Relationship in
                  match relation with
                  | Inverse -> Pigment.opposite o.pigment
                  | Direct  -> o.pigment
  }

let to_clot o = 
  { o with pigment = Pigment.Red;
         cytoplasm = Some Pigment.Red;
  }

let inject cytoplasm o =
  let c = Pigment.of_hels cytoplasm in
  let o = { o with cytoplasm = Some c } in
  if c == o.pigment then
    { o with pigment = Pigment.Red } else
      o 
