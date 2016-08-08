module Subscribe (Observer : T.TISSUE_OBSERVER) = struct
    
    module Weaver = StatisticableWeaver
    type t = { observer : Observer.t;
                   base : Weaver.t
	     }

    let subscribe observer weaver =
      {     base = weaver;
	observer = let tissue = Weaver.tissue weaver in
		   let observer =
                     Observer.init (Tissue.height tissue)
                                   (Tissue.width  tissue)
                                    observer
	           and set acc i v =
                     Observer.set i v acc in
		   tissue |> Tissue.items
                          |> Matrix.foldi set observer 
      }

    let statistics o =
      Weaver.statistics o.base
      
    let tissue o = Weaver.tissue o.base
    let index  o = o |> tissue
                     |> Tissue.weaver
    let item i o = o |> tissue
                     |> Tissue.items
                     |> Matrix.get (index o)
    let gaze o =
      Data.Nucleus.((o |> tissue
                       |> Tissue.fauna
                       |> Index.Map.find (index o)).gaze)
    let turn hand o =
      let i = index o in
      let previous = item i o
      and base = Weaver.turn hand o.base
      and current = item i o in
      let observer = 
	Observer.reset i previous current o.observer 
      in
      { observer;
	base
      }  

    type snap_t = 
      { acceptor_previous : Data.TissueItem.t;
           donor_previous : Data.TissueItem.t;
               acceptor_i : int * int;
	          donor_i : int * int
      }
       
    let snap o =
      let donor_i = index o in
      let acceptor_i = Index.move (gaze o) donor_i in
      { acceptor_previous = item acceptor_i o;
           donor_previous = item donor_i o;
               acceptor_i;
	          donor_i
      }      

    let next snap base o =
      let observer = 
	o.observer |> Observer.reset snap.donor_i 
				     snap.donor_previous 
				     (item snap.donor_i o)
                   |> Observer.reset snap.acceptor_i
				     snap.acceptor_previous
				     (item snap.acceptor_i o)
      in { base; observer }

    let pass o = 
      let open WeavingResult.OfPass in
      let snap = snap o in
      match Weaver.pass o.base with
      | Success base -> Success (next snap base o)
      | Dummy base   -> Dummy { o with base }

    let move act o = 
      let open WeavingResult.OfMove in
      let snap = snap o in
      match act o.base with
      | Success base -> Success (next snap base o)
      | Dummy base   -> Dummy { o with base }
      | Outed base   -> Outed (next snap base o)
      | Clot base    -> Clot (next snap base o)
      
    let replicate relation =
      move (Weaver.replicate relation) 
                      
    let move = 
      move Weaver.move

  end
