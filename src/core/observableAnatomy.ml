module Merge (Colony : COLONY.T) 
	     (Tissue : TISSUE.T)
           (Observer : T.ANATOMY_OBSERVER) = struct

    module Anatomy = Anatomy.Merge (Colony) (Tissue)  
    
    type t = { observer : Observer.t;
	         active : int * int;
                   base : Anatomy.t;
	     }
              
    let height  o = o.base |> Anatomy.height
    let width   o = o.base |> Anatomy.width
    let clotted o = o.base |> Anatomy.clotted
    let outed   o = o.base |> Anatomy.outed

    let is_out i    o = o.base |> Anatomy.is_out i 
    let nucleus i   o = o.base |> Anatomy.nucleus i
    let cytoplasm i o = o.base |> Anatomy.cytoplasm i

    open Data.Cell
    open Data.AnatomyItem

    let active_missing = (-1, -1)

    let make   ~colony:c
             ~observer:obs =

      let set observer i cytoplasm = 
	Observer.set i cytoplasm observer in
      { observer = Colony.foldxy set obs c;
	  active = active_missing;
            base = Anatomy.make c;
      }

    let observer_reset p c o =
      { o with observer = Observer.reset o.active o.observer
		              ~previous: p
		               ~current: c
      }

    let deactivate current_i o = 
      { ( if o.active = active_missing then o 
	  else if o.active <> current_i 
	  then match Anatomy.nucleus o.active o.base with

	       | Some n -> 
		  let c = Anatomy.cytoplasm o.active o.base in
		  let cell = { cytoplasm = c; nucleus = n } in
		  observer_reset (Active cell) (Static cell) o

	       | None   -> 
		  failwith ( "Impossible state: "
			     ^ "Active can point only to "
			     ^ "anatomy item with nucleus"
			   ) 
	  else o
	) with active = current_i
      }

    let cytoplasm_cell o = 
      let c = Anatomy.cytoplasm o.active o.base in
      let cell n = { cytoplasm = c; nucleus = n } in
      (Cytoplasm c), cell

    let set i value o =

      let o = deactivate i o in
      let cytoplasm, cell = cytoplasm_cell o in
      let cell n = Active (cell n) in
 
      let previous, current = 
	match (Anatomy.nucleus i o.base), value with
	| Some p, Some c -> (cell p),  (cell c)
	| Some p, None   -> (cell p), cytoplasm
	| None,   Some c -> cytoplasm, (cell c)
	| None,   None   -> failwith "redundant set"
      in

      let o = observer_reset previous current o in
      { o with base = Anatomy.set i value o.base }   

    let set_clot i value o = 

      let o = deactivate i o in
      let _, cell = cytoplasm_cell o in 
      let prev = match (Anatomy.nucleus i o.base) with
	         | Some n -> Static (cell n)
		 | None   -> 
		    failwith ( "Impossible state: "
			       ^ "Clot can appear only on "
			       ^ "Nucleus" 
			     ) in

      let o = observer_reset prev (Clot value) o in
      { o with base = Anatomy.set_clot i value o.base }

    let set_out i value o = 
      { (deactivate i o) with 
	observer = Observer.set_out i value o.observer;
            base = Anatomy.set_out i value o.base
      }
      
  end
