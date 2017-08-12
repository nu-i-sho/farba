module Make (Anatomy : ANATOMY.T) = struct
    
    module S = Shared
    
    type t = {   index : Index.t;
                  cell : Cell.t
               anatomy : Anatomy.t
             }

    type replication_result_t = | TissueCell of t
                                | Clot of S.Clot.t
                                | Out of Cell.t 

    let activate o =
      let item = S.TissueItem.ActiveCell o.cell in
      let item = S.AnatomyItem.Tissue item in
      let () = Anatomy.set o.index item o.anatomy in
      o

    let deactivate o =
      let item = S.TissueItem.Cell o.cell in
      let item = S.AnatomyItem.Tissue item in
      let () = Anatomy.set o.index item o.anatomy in
      o

    let make ~anatomy:a 
               ~first:cell
	       ~index:i =
      
      if Anatomy.mem i a 
      then match Anatimy.colony_get i a with
	   | S.ColonyItem.Empty -> 
	      Some (activate { index = i; anatomy = a; cell })
	   | _ -> 
	      None 
      else None

    let value_of o = o.cell
    
    let turn side o =
      activate { o with cell = (Cell.turn side o.cell) }

    let replicate relation o =
      let () = ignore(deactivate o)
      and nucleus = Cell.replicate relation o.cell
      and index' = Index.move o.cell.gaze o.index  
      if Anatomy.mem index' o.anatomy then
	
	let open S.AnatomyItem in
        let open S.ColonyItem in
	let open S.TissueItem in
	
	match Anatomy.get index' o.anatomy with

	| Colony Empty         
	  -> Tissue (Nucleus nucleus)

	| Colony (Cytoplasm plasm) 
	  -> Tissue (Nucleus Nucleus.inject plasm nucleus)

	| Tissue (ActiveCell _)  
	| Tissue (Cell _)
	  -> Tissue (Clot { gaze = nucleus.gaze })

	| Tissue (Clot _)
	  -> Tissue (Clot { gaze = nucleus.gaze })

	| Tissue (Out 

  end
