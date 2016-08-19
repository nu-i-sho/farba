module Make (Weaver : STATISTICABLE_WEAVER.T) = struct

    open Contracts
    module Subscribe (Observer : CALL_STACK_OBSERVER.T) = struct
        module Runtime = StatisticableRuntime.Make (Weaver)    
        type weaver_t = Weaver.t
        type t = { observer : Observer.t;
                       base : Runtime.t
                 }

        let snap base =
          Data.RuntimePoint.(
            { call_stack_top = Runtime.call_stack_top base;
                        mode = Runtime.mode base
            })
               
        let make observer weaver solution =
          let commands = Solution.to_array solution 
          and base = Runtime.make weaver solution in
          let observer =
            Observer.init commands (snap base) observer in
          { observer;
            base
          }
          
        let mode           o = o.base |> Runtime.mode 
        let weaver         o = o.base |> Runtime.weaver
        let solution       o = o.base |> Runtime.solution
        let call_stack_top o = o.base |> Runtime.call_stack_top
        let statistics     o = o.base |> Runtime.statistics

        let tick o =
          let previous = snap o.base
          and base_result = Runtime.tick o.base in
          let current = snap Statused.(base_result.value) in
          let observer =
            Observer.reset previous current o.observer
          in

          Statused.(   
            { status = base_result.status;
               value = { observer; base = base_result.value }
            })
      end
  end
