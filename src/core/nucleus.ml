type t = 
  { pigment : Pigment.t;
       gaze : Side.t
  }

let make pigment gaze =
  { pigment;
    gaze
  }
    
let is_cancer o = 
    match o.pigment with
    | Pigment.(Blue | Gray) -> false
    | Pigment.(   White   ) -> true

let turn dir o =
  let gaze = Side.turn dir o.gaze in
  { o with gaze 
  }

let rev_gaze o =
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
  let gaze = Side.rev o.gaze
  and pigment = 
    ( match gene with
      | Gene.Recessive -> Pigment.rev
      | Gene.Dominant  -> Fun.id
    ) o.pigment in
  { pigment;
    gaze
  }
