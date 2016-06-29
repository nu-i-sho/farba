type t = {  tissue : Tissue.t;
            colony : Colony.t;
             index : Index.t;
           nucleus : Nucleus.t
	 }

type out_t = | Cell of t
             | Clot
             | Out

let is_out (x, y) colony = x < 0 
                        || y < 0 
                        || x >= (Colony.width  colony) 
                        || y >= (Colony.height colony)

let make ~colony:c
          ~index:i
        ~nucleus:n = 

  if is_out i c then Out else
    let n = Nucleus.inject (Colony.get i c) n in
    let item = TissueItem.Cell n in
    Cell {  tissue = Tissue.set i item Tissue.empty;
            colony = c;
	     index = i;
           nucleus = n
	 }
  
let turn hand o =
  let n = Nucleus.turn hand o.nucleus in
  let item = TissueItem.Cell n in
  { o with tissue = Tissue.set o.index item o.tissue;
          nucleus = n
  }

let clot i o =
  let open Data.Nucleus in
  let clot = TissueItem.Clot (Side.opposite o.nucleus.gaze) in
  let () = ignore (Tissue.set i clot o.tissue) in
    Clot

let transform next o = 
  let open Data.Nucleus in
  let i = Index.move o.nucleus.gaze o.index in
  if is_out i o.colony then Out else
    match Tissue.get i o.tissue with
    | TissueItem.Clot _ -> clot o.index o
    | TissueItem.Cell _ -> clot i o
    | TissueItem.None   -> let n, t = next i in
			   Cell { o with nucleus = n; 
                                          tissue = t;
					   index = i 
				}	    
				   
let move o =
  let next i =
    let cytoplasm = Colony.get i o.colony in
    let n = Nucleus.inject cytoplasm o.nucleus in
    n, (o.tissue |> Tissue.set i (TissueItem.Cell n)
                 |> Tissue.set o.index TissueItem.None)
  in

  transform next o

let replicate relation o = 
  let next i =
    let cytoplasm = Colony.get i o.colony in
    let n = Nucleus.replicate relation cytoplasm o.nucleus in
    n, (Tissue.set i (TissueItem.Cell n) o.tissue)
  in

  transform next o
