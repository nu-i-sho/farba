module Merge (Fst : MATRIX.T)
             (Snd : MATRIX.T)
             (Res : sig type e end) = struct

      type e = Res.e
      type t = { matrix : Fst.t * Snd.t;
	          merge : Fst.e -> Snd.e -> e;
	       }
      
      let merge merge fst snd =
	{ matrix = fst, snd;
	   merge; 
	}

      let fst o = fst o.matrix
      let snd o = snd o.matrix

      let set_fst matrix o =
	{ o with matrix = matrix, (snd o) }

      let set_snd matrix o =
	{ o with matrix = (fst o), matrix }

      let height o = A.height (fst o)
      let width  o = A.width  (fst o)
      
      let get i o = 
	o.merge (Fst.get i (fst o))
		(Snd.get i (snd o))
    end
  end
