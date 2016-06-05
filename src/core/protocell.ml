module Kind = struct
    type t = | Hels
	     | Clot
	     | Cancer
end

type t = {   pigment : Pigment.t;
                gaze : HexagonSide.t;
           cytoplasm : Pigment.t option;
	 }

let first = {   pigment = Pigment.Blue;
		   gaze = HexagonSide.Up;
              cytoplasm = None;
	    }

let kind_of x = 
  match x.pigment, x.cytoplasm with
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
         cytoplasm = Some Pigment.Red;
  }

let replicate_to_protocell
       ~relationship:r 
              ~donor:d 
           ~acceptor:a =

  match kind_of a with
  | Kind.Clot -> (to_clot d), a
  | _ -> let child = replicate ~relationship:r ~donor:d in
          d, ({ d with cytoplasm = a.cytoplasm;
                         pigment = Pigment.Red; 
	     })

let replicate_to_cytoplasm 
      ~relationship:r 
             ~donor:d 
          ~acceptor:a =

  let cytoplasm = Pigment.of_hels a in
  let child = replicate ~relationship:r ~donor:d in
  let child = if cytoplasm == child.pigment then
		{ child with pigment = Pigment.Red } else
		  child 
  in

  { child with cytoplasm = Some cytoplasm }
