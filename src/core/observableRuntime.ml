module Make (Weaver : STATISTICABLE_WEAVER.T) = struct

    open CONTRACTS
    module Subscribe (Observer : CALL_STACK_OBSERVER.T) = struct
        module Runtime = StatisticableRuntime.Make (Weaver)    
        type weaver_t = Weaver.t
        type t = { observer : Observer.t;
                       base : Runtime.t
                 }
               
        let make observer weaver solution =
          let commands = Solution.to_array solution 
          and base = Runtime.make weaver solution in
          { observer = Observer.init commands
                                    (Runtime.top_crumb base)
                                    (Runtime.mode base)
                                     observer;
            base
          }
          
        let statistics o = o.base |> Runtime.statistics  
        let top_crumb  o = o.base |> Runtime.top_crumb
        let solution   o = o.base |> Runtime.solution
        let weaver     o = o.base |> Runtime.weaver
        let mode       o = o.base |> Runtime.mode 
        
        let tick o =
          let previous = o.base
          and result = Runtime.tick o.base in
          let current = Statused.(result.value) in

          let observer =
            Observer.update_top_crumb
              (Runtime.top_crumb previous)
              (Runtime.top_crumb current)
               o.observer
          in
          
          let observer =
            let previous_mode = Runtime.mode previous
            and current_mode = Runtime.mode current in
            if previous_mode = current_mode then
              observer else
              Observer.update_mode
                previous_mode
                current_mode
                observer
          in
          
          Statused.(   
            { status = result.status;
               value = { observer; base = current }
            })
      end
  end
