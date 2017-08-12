open Data

module Stage = struct
    type t = | Run
             | GoTo of DotsOfDice.t
             | Return
             | RunNext

    let to_active =
      function | GoTo _
               | Return
               | RunNext -> ActiveCrumbStage.Find
               | Run     -> ActiveCrumbStage.Run
  end
                       
type t = {   code : Code.t;
           crumbs : Crumbs.t;
            stage : Stage.t;
           output : Action.t option
         }

let make code =
  { crumbs = Crumbs.origin;
     stage = Stage.RunNext;
    output = None;
      code
  }

let output o = o.output
let crumbs o = o.crumbs
let length o = Code.length o.code
  
let active_item o =
  let i, top = Crumbs.top o.crumbs in
  ProgramActiveItem.(
    { value = Code.item i o.code;
      crumb = ProgramActiveCrumb.(
                { stage = Stage.to_active o.stage;
                  value = top
                })
    })

let item i o =
  ProgramItem.( ProgramCrumb.(
    { value = Code.item i o.code;
      crumb = let j, top = Crumbs.top o.crumbs in
              if j = i then
                let stage = Stage.to_active o.stage in
                Some { stage = CrumbStage.Active stage;
                       value = top
                     } else

                match Crumbs.maybe_item i o.crumbs with
                | None       -> None
                | Some crumb -> Some { stage = CrumbStage.Wait;
                                       value = crumb
                                     }
      }
  ))

let maybe_item i o =
  if i >= 0 && i < length o then
    Some (item i o) else
    None
  
let run i o =
  match Code.item i o.code with

  | Command.Nope
    -> { o with crumbs = Crumbs.succ o.crumbs;
                output = None
       }
    
  | Command.Act action
    -> { o with crumbs = Crumbs.succ o.crumbs;
                output = Some action
       }
     
  | Command.Call procedure
    -> { o with crumbs = Crumbs.split o.crumbs;
                 stage = Stage.GoTo procedure;
                output = None
       }
     
  | Command.Declare _
  | Command.End
    -> { o with crumbs = Crumbs.pred o.crumbs;
                 stage = Stage.Return;
                output = None
       }

let go_to x i o =
  { o with crumbs = Crumbs.succ o.crumbs;
            stage = match Code.item index o with
                    | Command.Declare y when x = y
                        -> Stage.Run
                    | _ -> Stage.GoTo x
  }

let return o =
  { o with crumbs = Crumbs.pred o.crumbs;
            stage = Doubleable.(
                      match Crumbs.top o.crumbs with
                      | _, (Single _) -> Stage.Return
                      | _, (Double _) -> Stage.RunNext
                    )
  }

let run_next o =
  { o with crumbs = Crumbs.succ o.crumbs;
            stage = Stage.Run
  }
  
let succ o =
  match o.stage with
  | Stage.Run     -> run i o
  | Stage.GoTo x  -> go_to x i o
  | Stage.Return  -> return o
  | Stage.RunNext -> run_next o
