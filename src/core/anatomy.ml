module Merge (Colony : COLONY.T) 
             (Tissue : TISSUE.T) = struct

    type t = {  tissue : Tissue.t;
	        colony : Colony.t;
               clotted : bool;
                 outed : bool
	     }

    let width  o = Colony.width  o.colony 
    let height o = Colony.height o.colony
    
    let is_out (x, y) o = 
      x < 0 || x >= (Colony.width  o.colony) ||
      y < 0 || y >= (Colony.height o.colony)
  
    let cytoplasm i o = Colony.get i o.colony
    let nucleus   i o = Tissue.get i o.tissue
 
    let set i v o = 
      { o with tissue = Tissue.set i v o.tissue }

    let set_clot _ _ o = { o with clotted = true }
    let set_out  _ _ o = { o with outed = true }

    let clotted o = o.clotted
    let outed   o = o.outed

    let merge ~colony:c
              ~tissue:t =
      {  tissue = t;
	 colony = c;
	clotted = false;
          outed = false
      }
  end
