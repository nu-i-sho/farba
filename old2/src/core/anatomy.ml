module Merge (Colony : COLONY.T) 
             (Tissue : TISSUE.T) = struct

    type t = { tissue : Tissue.t;
	       colony : Colony.t
	     }

    let width  o = Colony.width  o.colony 
    let height o = Colony.height o.colony
    let mem i  o = Colony.mem i  o.colony

    let merge ~colony:c
              ~tissue:t =
      `{ tissue = t;
	 colony = c
       }
  
    let colony_get i o = Colony.get i o.colony
    let tissue_get i o = Tissue.get i o.tissue

    let get i o = 
      if Tissue.mem i o.tissue then
	S.AnatomyItem.Tissue (tissue_get i o) else
	S.AnatomyItem.Colony (colony_get i o)

    let set i v o =
      { o with tissue = Tissue.set i v o.tissue }

  end
