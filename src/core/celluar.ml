type t = {   pigment : Pigment.t;
                gaze : HexagonSide.t;
           cytoplazm : Pigment.t option;
             program : Command.t array;
              spirit : Breadcrumbs.t option;
	        mode : LifeMode.t;
	 }

module Kind = struct
    type t = | Hels
	     | Clot
	     | Cancer
end

module State = struct
    type t = {    pigment : Pigment.t;
                     gaze : HexagonSide.t;
                cytoplazm : Pigment.t option;
	       has_spirit : bool;
	             kind : Kind.t
	     }
end

let first program = {   pigment = Pigment.Blue;
			   gaze = HexagonSide.Up;
                      cytoplazm = None;
                         spirit = Some Breadcrumbs.start;
                           mode = LifeMode.Run;
			program;
		    }
let kind pigment cytoplazm = 
  match pigment, cytoplazm with
  | _          , Some Pigment.Red -> Kind.Clot
  | Pigment.Red, _                -> Kind.Cancer
  | _                             -> Kind.Hels

let state_of {   pigment = p;
                    gaze = g;
               cytoplazm = c;
                 program = _;
                  spirit = s;
	            mode = _;
	     } = 
  State.({       kind = kind p c;
	   has_spirit = s != None;	      
	      pigment = p;
		 gaze = g;
	    cytoplazm = c;
	 })

let turn side x =
  { x with gaze = x.gaze |> HexagonSide.turn side }

let replicate relationship x =       
                                          (* parent: *)
    { x with spirit = None; 
               mode = LifeMode.Free
    },                                    (* child:  *) 
    { x with    gaze = HexagonSide.opposite x.gaze;
             pigment = let open Relationship in
                       match relationship with
		       | Inverse -> Pigment.opposite x.pigment
		       | Direct  -> x.pigment
    }                                         

let to_clot x = 
  { x with pigment = Pigment.Red;
         cytoplazm = Some Pigment.Red;
            spirit = None
  }

let replicate_to_celluar 
      relationship 
          ~donor:d 
       ~acceptor:a =

  match (state_of a).kind with
  | Kind.Clot -> (to_clot d), a
  | _         -> 
     let parent, child = replicate relationship d in
     let child = 
       { child with cytoplazm = a.cytoplazm;
		      pigment = Pigment.Red; 
       }
     in

     parent, child

let replicate_to_cytoplazm 
      relationship 
          ~donor:d 
       ~acceptor:a =

  let parent, child = replicate relationship d in
  let cytoplazm = Pigment.of_hels a in
  let pigment = if cytoplazm == child.pigment then
		  Pigment.Red else
		  child.pigment
  in

  let child = 
    { child with cytoplazm = Some cytoplazm; 
		 pigment; 
    } 
  in
  
  parent, child
