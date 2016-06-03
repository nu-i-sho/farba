type t = Nucleus.t;

let make x = x

let nucleus_pigment = 
  Nucleus.pigment

let cytoplazm_pigment x =
  x |> nucleus_pigment
    |> Pigment.opposite

let spirit =
  Nucleus.spirit

let with_spirit =
  Nucleus.with_spirit

let is_cancer =
  Nucleus.is_cancer

let turn =
  Nucleus.turn 

let replicate =
  Nucleus.replicate
