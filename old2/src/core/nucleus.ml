module S = Shared

module Hels = struct
    type t = S.Nucleus.Hels.t
    open Nucleus.Hels
  
    let turn hand o =
      { o with gaze = Side.turn hand o.gaze }

    let replicate relation o = 
      let pigment = 
	let open Relationship in 
	match relation with
	| Inverse -> Pigment.opposite o.pigment 
	| Direct  -> o.pigment
      in

      { pigmnet;
	   eyes = Pigment.opposite pigment;
	   gaze = Side.opposite o.gaze
      }
	
    let inject cytoplasm o =
      let nucleus = 
	if o.pigment = cytoplasm.pigment then
	  let open S.Nucleus.Cancer in
	  S.Nucleus.Cancer { gaze = o.gaze } else
	  S.Nucleus.Hels o
      in 

      Cytocell.({ cytoplasm; nucleus })
  end

module Cancer : sig
    type t = Nucleus.Cancer.t
    open Nucleus.Cancer
      
    let turn hand o =
      { o with gaze = Side.turn hand o.gaze }

    let replicate _ o =
      { gaze = Side.opposite o.gaze }
      
    let inject cytoplasm o = 
      Cytocell.({ cytoplasm; 
                    nucleus = S.Nacleus.Cancer o 
               })
  end
 
type t = Nucleus.t

let turn hand = 
  function | Hels   x -> Hels (Hels.turn hand x)
           | Cancer x -> Cancer (Cancer.turn hand x)

let replicate relation =
  function | Hels   x -> Hels (Hels.replicate relation x)
           | Cancer x -> Cancer (Cancer.replicate relation x)
 
let inject cytoplasm =
  function | Hels   x -> Hels (Hels.inject cytoplasm x)
           | Cancer x -> Cancer (Cancer.inject cytoplasm x)

 
