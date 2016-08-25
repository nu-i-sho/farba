module Make (Crumbs : BREADCRUMBS.T)
            (Weaver : WEAVER.T) = struct
  
    module Commander = WeaverCommander.Make (Weaver)
    module Mode = Data.RuntimeMode               
    open Data

    type crumbs_t = Crumbs.t
    type weaver_t = Weaver.t
    type t = { solution : Solution.t;
                 weaver : weaver_t;
                 crumbs : crumbs_t  
             }
           
    let make solution weaver crumbs =
      { solution; weaver; crumbs }

    let weaver   o = o.weaver
    let solution o = o.solution
      
    let command i o =
      Solution.command i o.solution

    let success crumbs o =
      Statused.({ status = TickStatus.Success;
                   value = { o with crumbs }
               })
      
    let run index o =
      match command index o with
        
      | Command.Act action
        -> let result = Commander.do' action o.weaver in
           Statused.(
             { status = result.status;
                value = { o with weaver = result.value;
                                 crumbs = Crumbs.move o.crumbs
                        }})

      | Command.Call proc
        -> success (o.crumbs |> Crumbs.split
                             |> Crumbs.with_mode (Mode.GoTo proc)) o
      | Command.Declare _
      | Command.End
        -> success (o.crumbs |> Crumbs.back
                             |> Crumbs.with_mode Mode.Return) o
      | Command.Nope
        -> success (o.crumbs |> Crumbs.move) o

    let go_to x index o =
      success (o.crumbs |> Crumbs.move
                        |> Crumbs.with_mode
                             ( match command index o with
                               | Command.Declare y when x = y
                                   -> Mode.Run
                               | _ -> Mode.GoTo x )) o
    let return o =
      let crumb_value = Crumb.((Crumbs.top o.crumbs).value) in
      success (o.crumbs |> Crumbs.back
                        |> Crumbs.with_mode
                             Doubleable.(       
                               match crumb_value with
                               | Single _      -> Mode.Return
                               | Double (_, _) -> Mode.RunNext )) o
    let run_next o =
      success (o.crumbs |> Crumbs.move
                        |> Crumbs.with_mode Mode.Run) o
    let tick o =
      let i = Crumb.((Crumbs.top o.crumbs).index) in
      if i < 0 || i >= (Solution.length o.solution) then
        Statused.({ status = TickStatus.OutOfSolution;
                     value = o
                 }) else
        
        match Crumbs.mode o.crumbs with
        | Mode.Run     -> run i o
        | Mode.GoTo x  -> go_to x i o
        | Mode.Return  -> return o
        | Mode.RunNext -> run_next o
  end
