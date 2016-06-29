module Make (Anatomy : ANATOMY.T) = struct
   
    type t = { pcyto : int;
               ucyto : int;
               hcell : int;
               ccell : int;
                clot : bool;
                 out : bool
	     }

    let calculate anatomy = 

      let height = Anatomy.height anatomy
      and width  = Anatomy.width  anatomy in
      let rec calc x y acc = 
	if y = height then acc else
	  if x = width then calc 0 (y + 1) acc else
	    
	    let open Data.Nucleus in
	    let module P = Data.Pigment in
	    ( match (Anatomy.cytoplasm (x, y) anatomy), 
	            (Anatomy.cell (x, y) anatomy) with
	    
	      | P.None, Some _ 
		-> { acc with ccell = acc.ccell + 1 }

	      | (P.Blue | P.Gray), None   
		-> { acc with ucyto = acc.ucyto + 1;
                              pcyto = acc.pcyto + 1 
		   }

	      | (P.Blue | P.Gray), Some { pigment = P.None }
		-> { acc with ccell = acc.ccell + 1; 
                              pcyto = acc.pcyto + 1
		   }

	      | (P.Blue | P.Gray), 
		Some { pigment = (P.Blue | P.Gray) }
		-> { acc with hcell = acc.hcell + 1;
			      pcyto = acc.pcyto + 1
		 }

	      | P.None, None
		-> acc

	    ) |> calc (x + 1) y
      in 

      calc 0 0 {   out = Anatomy.outed anatomy;
	          clot = Anatomy.clotted anatomy;
	         pcyto = 0;
		 ucyto = 0;
		 hcell = 0;
		 ccell = 0
	       }

    let pigmented_cytoplasm o = o.pcyto
    let uncovered_cytoplasm o = o.ucyto

    let hels_cells   o = o.hcell
    let cancer_cells o = o.ccell
    let cells        o = o.hcell + o.ccell

    let has_clot o = o.clot
    let is_outed o = o.out
    
  end
