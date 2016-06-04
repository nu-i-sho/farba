module Kind = struct
    type t = | Hels
	     | Clot
	     | Cancer
end

type t = {   pigment : Pigment.t;
                gaze : HexagonSide.t;
           cytoplazm : Pigment.t option;
	 }

let first = {   pigment = Pigment.Blue;
		   gaze = HexagonSide.Up;
              cytoplazm = None;
	    }

let kind_of x = 
  match x.pigment, x.cytoplazm with
  | _          , Some Pigment.Red -> Kind.Clot
  | Pigment.Red, _                -> Kind.Cancer
  | _                             -> Kind.Hels

let turn side x =
  { x with gaze = x.gaze |> HexagonSide.turn side }

let replicate ~relationship:r ~donor:x =       
    { x with    gaze = HexagonSide.opposite x.gaze;
             pigment = let open Relationship in
                       match r with
		       | Inverse -> Pigment.opposite x.pigment
		       | Direct  -> x.pigment
    }                                         

let to_clot x = 
  { x with pigment = Pigment.Red;
         cytoplazm = Some Pigment.Red;
  }

let replicate_to_celluar 
       ~relationship:r 
              ~donor:d 
           ~acceptor:a =

  match kind_of a with
  | Kind.Clot -> (to_clot d), a
  | _ -> let child = replicate ~relationship:r ~donor:d in
          d, ({ d with cytoplazm = a.cytoplazm;
                       pigment = Pigment.Red; 
	     })

let replicate_to_cytoplazm 
      ~relationship:r 
             ~donor:d 
          ~acceptor:a =

  let cytoplazm_pigment = Pigment.of_hels a in
  let cytoplazm = Some cytoplazm_pigment in
  let child = replicate ~relationship:r ~donor:d in
  let child = if cytoplazm_pigment == child.pigment then
		{ child with pigment = Pigment.Red } else
		  child 
  in

  { child with cytoplazm }
