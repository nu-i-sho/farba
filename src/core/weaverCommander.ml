module Make (Weaver : WEAVER.T) = struct
    type t = Weaver.t
    let do' action weaver =
      Data.( match action with
        
             | Action.Pass
               -> let result = Weaver.pass weaver in
                  Statused.(
                    { status = TickStatus.of_pass result.status;
                       value = result.value
                    })
      
             | Action.Move
               -> let result = Weaver.move weaver in
                  Statused.(
                    { status = TickStatus.of_move result.status;
                       value = result.value
                    })

             | Action.Replicate relation
               -> let result = Weaver.replicate relation weaver in
                  Statused.(
                    { status = TickStatus.of_move result.status;
                       value = result.value
                    })
                  
             | Action.Turn hand
               -> Statused.(
                 { status = TickStatus.Success;
                    value = Weaver.turn hand weaver
                  })
      )
  end
