type t = Nucleus.t;

let make x = x

let nucleus_pigment x = 
   x |> Nucleus.pigment_of

let cytoplazm_pigment x =
  x |> nucleus_pigment
    |> Pigment.opposite

let is_cancer x =
  Nucleus.is_cancer x.nucleus

let turn side x =
  let nucleus = 
    x.nucleus |> Nucleus.turn side 
  in
 
  { x with nucleus }

let replicate relationship x = 
  let parent, child = 
    x.nucleus |> Nucleus.replicate relationship
  in

  { x with nucleus = parent }, 
  child
