module Make (Colony : COLONY.T) = struct

    type t = {  tissue : Tissue.t;
                colony : Colony.t;
                 index : Index.t;
               nucleus : Nucleus.t
	     }

    type out_t = | Cell of t
                 | Clot
                 | Out

    let is_out (x, y) colony = 
      x < 0 || x >= (Colony.width  colony) ||
      y < 0 || y >= (Colony.height colony)

    let make ~colony:c
              ~index:i
            ~nucleus:n = 

      if is_out i c then Out else
	let n = Nucleus.inject (Colony.get i c) n in
	Cell {  tissue = Tissue.set i (Some n) Tissue.empty;
                colony = c;
	         index = i;
               nucleus = n
	     }
  
    let turn hand o =
      let n = Nucleus.turn hand o.nucleus in
      { o with tissue = Tissue.set o.index (Some n) o.tissue;
              nucleus = n
      }

    let transform next o = 
      let open Data.Nucleus in
      let index = Index.move o.nucleus.gaze o.index in
      if is_out index o.colony then Out else
	match Tissue.get index o.tissue with
	| Some _ -> Clot
	| None   -> let nucleus, tissue = next index in
		    Cell { o with nucleus; tissue; index }  
				   
    let move o =
      let next i =
	let cytoplasm = Colony.get i o.colony in
	let n = Nucleus.inject cytoplasm o.nucleus in
	n, (o.tissue |> Tissue.set i (Some n)
                     |> Tissue.set o.index None)
      in

      transform next o

    let replicate relation o =
      let next i =
	let cyto = Colony.get i o.colony in
	let n = Nucleus.replicate relation cyto o.nucleus in
	n, (Tissue.set i (Some n) o.tissue)
      in

      transform next o
  end
