module Make (Anatomy : ANATOMY.T) = struct

    type t = { anatomy : Anatomy.t;
               nucleus : Nucleus.t;
                 index : int * int
	     }
 
    type out_t = | Cell of t
                 | Clot of Anatomy.t
                 | Out  of Anatomy.t

    let make ~anatomy:a
               ~index:i
             ~nucleus:n = 

      if Anatomy.is_out i a then 
	Out (Anatomy.set_out i n a) else
	let n = Nucleus.inject (Anatomy.cytoplasm i a) n in
	Cell { anatomy = Anatomy.set i (Some n) a;
               nucleus = n;
	         index = i
	     }

    let index o   = o.index
    let anatomy o = o.anatomy

    let turn hand o =
      let n = Nucleus.turn hand o.nucleus in
      let item = Some n in
      { o with anatomy = Anatomy.set o.index item o.anatomy;
	       nucleus = n
      }

    let transform next o = 
      let gaze  = Data.Nucleus.(o.nucleus.gaze) in
      let i = Index.move gaze o.index in
      let nucleus, anatomy = next i in

      if Anatomy.is_out i anatomy then 
	Out (Anatomy.set_out i nucleus anatomy) else 
	match Anatomy.nucleus i anatomy with
	| Some _ -> let gaze = Data.Nucleus.(nucleus.gaze) in
	            Clot (Anatomy.set_clot i gaze anatomy)
	| None   -> Cell { nucleus; anatomy; index = i }
				   
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
