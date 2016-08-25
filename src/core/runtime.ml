module Make (Weaver : WEAVER.T) = struct
    module Commander = WeaverCommander.Make (Weaver)
    open Data
       
    type weaver_t = Weaver.t
    type t = {   weaver : weaver_t;
               solution : Solution.t;
                 crumbs : Breadcrumbs.t;
                   mode : RuntimeMode.t
             }
           
    let make weaver solution =
      {     weaver;
          solution;
            crumbs = Breadcrumbs.start;
              mode = RuntimeMode.GoTo DotsOfDice.O
      }

    let mode     o = o.mode
    let weaver   o = o.weaver
    let solution o = o.solution
                   
    let top_crumb o =
      Breadcrumbs.top o.crumbs

    let command i o =
      Solution.command i o.solution

    let is_out_of_solution index o =
      index < 0 || index >= (Solution.length o.solution)

    let success value =
      Statused.({ status = TickStatus.Success;
                   value
               })
      
    let run index o =
      match command index o with
        
      | Command.Act action
        -> let result = Commander.do' action o.weaver in
           Statused.(
             { status = result.status;
                value = { o with weaver = result.value;
                                 crumbs = Breadcrumbs.move o.crumbs
                        }})

      | Command.Call procedure
        -> success { o with crumbs = Breadcrumbs.split o.crumbs;
                              mode = RuntimeMode.GoTo procedure
                   }
           
      | Command.Declare _
      | Command.End
        -> success { o with crumbs = Breadcrumbs.back o.crumbs;
                              mode = RuntimeMode.Return
                   }
         
      | Command.Nope
        -> success { o with crumbs = Breadcrumbs.move o.crumbs
                   }

    let go_to x index o = 
      success { o with crumbs = Breadcrumbs.move o.crumbs;
                         mode = match command index o with
                                | Command.Declare y when x = y
                                    -> RuntimeMode.Run
                                | _ -> RuntimeMode.GoTo x
              }

    let return o =
      let crumb_value = Crumb.((top_crumb o).value) in
      success { o with crumbs = Breadcrumbs.back o.crumbs;
                         mode = let module D = Doubleable in
                                let module M = RuntimeMode in       
                                match crumb_value with
                                | D.Single _      -> M.Return
                                | D.Double (_, _) -> M.RunNext
              }

    let run_next o =
      success { o with crumbs = Breadcrumbs.move o.crumbs;
                         mode = RuntimeMode.Run
              }
      
    let tick o =
      let i = Crumb.((top_crumb o).index) in
      if is_out_of_solution i o then
        Statused.({ status = TickStatus.OutOfSolution;
                     value = o
                 }) else
        
        RuntimeMode.( match o.mode with
                      | Run     -> run i o
                      | GoTo x  -> go_to x i o
                      | Return  -> return o
                      | RunNext -> run_next o
                    )
  end
