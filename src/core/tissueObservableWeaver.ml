module Subscribe (Observer : CONTRACTS.TISSUE_OBSERVER.T) = struct

    open Data
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
                     Observer.init_item i v acc in
		   tissue |> Tissue.init_items
                          |> Matrix.foldi set observer 
      }

    let statistics o =
      Weaver.statistics o.base
      
    let tissue o = Weaver.tissue o.base
    let index  o = o |> tissue
                     |> Tissue.weaver
    let item i o = o |> tissue
                     |> Tissue.items
                     |> Matrix.get i
    let gaze o =
      Nucleus.((o |> tissue
                  |> Tissue.fauna
                  |> Index.Map.find (index o)).gaze)

    let turn hand o =
      let i = index o in
      let previous = item i o
      and base = Weaver.turn hand o.base
      and current = item i o in
      let update = TissueItemUpdateExt.of_change previous current in
      let observer = Observer.update_item i update o.observer 
      in
      { observer;
	base
      }  

    type snap_t = 
      { acceptor_previous : TissueItem.t;
           donor_previous : TissueItem.t;
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
      let donor_update =
        TissueItemUpdateExt.of_change snap.donor_previous 
	                             (item snap.donor_i o)
      and acceptor_update =
        TissueItemUpdateExt.of_change snap.acceptor_previous
	                             (item snap.acceptor_i o) in
      let observer = 
	o.observer |> Observer.update_item snap.donor_i
                                           donor_update
                   |> Observer.update_item snap.acceptor_i
                                           acceptor_update
      in { base; observer }

    let pass o = 
      let base = Weaver.pass o.base
      and snap = snap o in
      let observed x =
        Statused.(
          match x.status with
          | PassStatus.Success -> next snap x.value o
          | PassStatus.Dummy   -> { o with base = x.value }
        ) in
      Statused.map observed base 

    let observable_move act o =
      let base = act o.base
      and snap = snap o in
      let observed x =
        Statused.(
          match x.status with
          | MoveStatus.Success 
          | MoveStatus.Outed 
          | MoveStatus.Clot  -> next snap x.value o
          | MoveStatus.Dummy -> { o with base = x.value }
        ) in
      Statused.map observed base
      
    let replicate relation =
      observable_move (Weaver.replicate relation) 
                      
    let move = 
      observable_move Weaver.move

  end
