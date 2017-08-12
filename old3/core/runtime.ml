module Make (Crumbs : BREADCRUMBS.T)
            (Weaver : CORE.WEAVER.T) = struct

    open Data
  
    module Stage = RuntimeStage
    module Mode  = RuntimeMode

    type crumbs_t = Crumbs.t
    type weaver_t = Weaver.t
    type t = { solution : Solution.t;
                 weaver : weaver_t;
                 crumbs : crumbs_t;
                  stage : Stage.t
             }
           
    let make solution weaver crumbs =
      {    stage = Stage.Created;
        solution;
          weaver;
          crumbs
      }

    let stage    o = o.stage
    let weaver   o = o.weaver
    let solution o = o.solution
      
    let command i o =
      Solution.command i o.solution

    let do' =
      function | Action.Replicate relation
                                  -> Weaver.replicate relation
               | Action.Turn hand -> Weaver.turn hand
               | Action.Pass      -> Weaver.pass
               | Action.Move      -> Weaver.move
               
    let run index o =
      match command index o with
        
      | Command.Act action
        -> let weaver = do' action o.weaver in
           { o with weaver;
                    crumbs = Crumbs.move o.crumbs;
                     stage = weaver |> Weaver.stage
                                    |> Stage.of_weaver_stage
           }
           
      | Command.Call proc
        -> { o with stage = Stage.SuccessTicked;
                   crumbs = o.crumbs
                             |> Crumbs.split
                             |> Crumbs.with_mode (Mode.GoTo proc)
           }
         
      | Command.Declare _
      | Command.End
        -> { o with stage = Stage.SuccessTicked;
                   crumbs = o.crumbs
                             |> Crumbs.back
                             |> Crumbs.with_mode Mode.Return
           }
         
      | Command.Nope
        -> { o with stage = Stage.SuccessTicked;
                   crumbs = Crumbs.move o.crumbs
           }

    let go_to x index o =
      { o with stage = Stage.SuccessTicked;
              crumbs = o.crumbs
                        |> Crumbs.move
                        |> Crumbs.with_mode
                             ( match command index o with
                               | Command.Declare y when x = y
                                   -> Mode.Run
                               | _ -> Mode.GoTo x
                             )
      }
      
    let return o =
      let crumb_value = Crumb.((Crumbs.top o.crumbs).value) in
      { o with stage = Stage.SuccessTicked;
              crumbs = o.crumbs
                        |> Crumbs.back
                        |> Crumbs.with_mode
                             Doubleable.(       
                               match crumb_value with
                               | Single _      -> Mode.Return
                               | Double (_, _) -> Mode.RunNext
                             )
      }
      
    let run_next o =
      { o with stage = Stage.SuccessTicked;
              crumbs = o.crumbs |> Crumbs.move
                                |> Crumbs.with_mode Mode.Run
      }
      
    let tick o =
      let i = Crumb.((Crumbs.top o.crumbs).index) in
      if i < 0 || i >= (Solution.length o.solution) then
        { o with stage = Stage.OutedOfSolution } else
        
        match Crumbs.mode o.crumbs with
        | Mode.Run     -> run i o
        | Mode.GoTo x  -> go_to x i o
        | Mode.Return  -> return o
        | Mode.RunNext -> run_next o
  end
