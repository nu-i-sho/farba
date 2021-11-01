type t = 
  { pigment : Pigment.t;
       gaze : Side.t
  }

let make pigment gaze =
  { pigment;
    gaze
  }
    
let is_bastard o = 
  match o.pigment with
  | Pigment.(Blue | Gray) -> false
  | Pigment.(   White   ) -> true

let turn hand o =
  let gaze = Side.turn hand o.gaze in
  { o with gaze 
  }

let look_back o =
  let gaze = Side.rev o.gaze in
  { o with gaze 
  }
  
let inject cytoplasm o =
  let pigment = Pigment.(
      match o.pigment, cytoplasm with
      | White, _   | _, White 
      | Blue, Gray | Gray, Blue -> o.pigment
      | Blue, Blue | Gray, Gray -> White ) in
  { o with pigment
  }

let replicate gene o =
  let child_pigment =
    ( match gene with
      | Gene.Recessive -> o.pigment |> Pigment.recessive
      | Gene.Dominant  -> o.pigment
    ) in 
  { (look_back o) with
     pigment = child_pigment
  }
