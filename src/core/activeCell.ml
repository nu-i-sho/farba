module Make (Anatomy : ANATOMY.T) = struct

    type t = { anatomy : Anatomy.t;
               nucleus : Nucleus.t;
                 index : Index.t
	     }

    type out_t = | Cell of t
                 | Clot of Anatomy.t
                 | Out  of Anatomy.t

    let make ~anatomy:a
               ~index:i
             ~nucleus:n = 

      if Anatomy.is_out i a then Out a else
	let n = Nucleus.inject (Anatomy.cytoplasm i a) n in
	Cell { anatomy = Anatomy.set i (Some n) a;
               nucleus = n;
	         index = i
	     }
  
    let turn hand o =
      let n = Nucleus.turn hand o.nucleus in
      let cell = Some n in
      { o with anatomy = Anatomy.set o.index cell o.anatomy;
	       nucleus = n
      }

    let transform next o = 
      let gaze  = Data.Nucleus.(o.nucleus.gaze) in
      let index = Index.move gaze o.index in
      
      if Anatomy.is_out index o.anatomy 
      then Out (Anatomy.out o.anatomy) 
      else match Anatomy.cell index o.anatomy with
	   | Some _ -> Clot (Anatomy.clot o.anatomy)
	   | None   -> let nucleus, anatomy = next index in
		       Cell { nucleus; anatomy; index }
				   
    let move o =
      let next i =
	let cyto = Anatomy.cytoplasm i o.anatomy in
	let n = Nucleus.inject cyto o.nucleus in
	n, (o.anatomy |> Anatomy.set i (Some n)
                      |> Anatomy.set o.index None)
      in

      transform next o

    let replicate relation o =
      let next i =
	let cyto = Anatomy.cytoplasm i o.anatomy in
	let n = Nucleus.replicate relation cyto o.nucleus in
	n, (Anatomy.set i (Some n) o.anatomy)
      in

      transform next o
  end
