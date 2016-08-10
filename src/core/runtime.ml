module Make (Weaver : WEAVER.T) = struct

    module Mode = Data.RuntimeMode
    module Stack = CallStack
    module StackPoint = Data.CallStackPoint
    module Command = Data.Command

    type weaver_t = Weaver.t
    type t = {   weaver : weaver_t;
               solution : Solution.t;
                  stack : CallStack.t;
                   mode : Mode.t
             }
           
    let make weaver solution =
      {     weaver;
          solution;
             stack = Stack.start;
              mode = Mode.GoTo Data.DotsOfDice.O
      }

    let mode o = o.mode
    let weaver o = o.weaver
    let solution o = o.solution
    let call_stack_top o =
      Stack.top o.stack

    let command i o =
      Solution.command i o.solution

    let is_out_of_solution index o =
      index < 0 || index >= (Solution.length o.solution)

    let success value =
      Statused.({ status = TickStatus.Success;
                   value
               })
      
    let run index o =
      let status_of_pass =
        function | PassStatus.Success -> TickStatus.Success
                 | PassStatus.Dummy   -> TickStatus.Dummy
                    
      and status_of_move =
        function | MoveStatus.Success -> TickStatus.Success
                 | MoveStatus.Dummy   -> TickStatus.Dummy
                 | MoveStatus.Clot    -> TickStatus.TissueCloted
                 | MoveStatus.Outed   -> TickStatus.OutOfTissue
      in
                    
      match command index o with
        
      | Command.Pass
        -> let result = Weaver.pass o.weaver in
           Statused.(
             { status = status_of_pass result.status;
                value = { o with weaver = result.value;
                                  stack = Stack.increment o.stack
                        }})
      
      | Command.Move
        -> let result = Weaver.move o.weaver in
           Statused.(
             { status = status_of_move result.status;
                value = { o with weaver = result.value;
                                  stack = Stack.increment o.stack
                        }})

      | Command.Replicate relation
        -> let result = Weaver.replicate relation o.weaver in
           Statused.(
             { status = status_of_move result.status;
                value = { o with weaver = result.value;
                                  stack = Stack.increment o.stack
                        }})
           
      | Command.Turn hand
        -> success { o with weaver = Weaver.turn hand o.weaver;
                             stack = Stack.increment o.stack
                   }

      | Command.Call procedure
        -> success { o with stack = Stack.split o.stack;
                             mode = Mode.GoTo procedure
                   }
           
      | Command.Declare _
      | Command.End
        -> success { o with stack = Stack.decrement o.stack;
                             mode = Mode.Return
                   }
         
      | Command.Nope
        -> success { o with stack = Stack.increment o.stack
                   }

    let go_to x index o = 
      success { o with stack = Stack.increment o.stack;
                        mode = match command index o with
                               | Command.Declare y when x = y
                                   -> Mode.Run
                               | _ -> Mode.GoTo x
              }

    let return o =
      let open StackPoint in
      success { o with stack = Stack.decrement o.stack;
                        mode = match (call_stack_top o).value with
                               | Value.Single _      -> Mode.Return
                               | Value.Double (_, _) -> Mode.RunNext
              }

    let run_next o =
      success { o with stack = Stack.increment o.stack;
                        mode = Mode.Run
              }
      
    let tick o =
      let i = StackPoint.((call_stack_top o).index) in
      if is_out_of_solution i o then
        Statused.({ status = TickStatus.OutOfSolution;
                     value = o
                 }) else
        
        match o.mode with
        | Mode.Run     -> run i o
        | Mode.GoTo x  -> go_to x i o
        | Mode.Return  -> return o
        | Mode.RunNext -> run_next o

  end
