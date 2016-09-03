module Make (D : DEPENDENCIES.WEAVER) = struct

    open D.Core
    open Tools
    open Data
  
    module UpdateExt = TissueItemUpdateExt
    module Update = TissueItemUpdate
    module View = D.View.Tissue

    type tissue_t = Tissue.t
    type t = { base : Weaver.t;
               view : View.t
	     }
           
    let make weaver view =
      { base = weaver;
	view = let tissue = Weaver.tissue weaver in
	       let view   = View.init (Tissue.height tissue)
                                      (Tissue.width  tissue)
                                       view
	       and set acc i v =
                 View.init_item i v acc in
	       tissue |> Tissue.init_items
                      |> Matrix.foldi set view 
      }

    let statistics o = Weaver.statistics o.base
    let tissue o = Weaver.tissue o.base
    let stage o = Weaver.stage o.base
                 
    let index o =
      o |> tissue
        |> Tissue.weaver

    let item i base =
      base |> Weaver.tissue
           |> Tissue.items
           |> Matrix.get i
      
    let turn hand o =
      let i = index o in
      let previous = item i o.base
      and base = Weaver.turn hand o.base in 
      let current = item i base in
      let update = UpdateExt.of_change previous current in
      { view = View.update_item i update o.view;
        base
      }
      
    let view act o =
      
      let i = index o
      and base = act o.base
      and out view (i, item_update) =
        View.update_item i item_update view in
      
      let view =
        WeaverStage.(
          match Weaver.stage base with
          | Replicated Dummy -> [i, Update.(DummyAct Replicate)]
          | Passed Dummy     -> [i, Update.(DummyAct Pass)]
          | Moved Dummy      -> [i, Update.(DummyAct Move)]
          | _                ->
             let gaze o =
               Nucleus.(
                 (o |> tissue
                    |> Tissue.fauna
                    |> IntPointMap.find (index o)).gaze
               ) in
                 
             let j = Index.move (gaze o) i in
             let prev_donor    = item i o.base
             and prev_acceptor = item j o.base
             and donor    = item i base
             and acceptor = item j base in

             [ (i, UpdateExt.of_change prev_donor donor);
               (j, UpdateExt.of_change prev_acceptor acceptor)
             ]
        ) |> List.fold_left out o.view
      in { base; view }

    let replicate relation = view (Weaver.replicate relation)
    let pass = view Weaver.pass
    let move = view Weaver.move
  end
