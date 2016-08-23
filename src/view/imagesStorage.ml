module Decorate (Provider : IMAGES_PROVIDER.T
                              with type result_t = Image.t) = struct
    open Data

    module CommandMap = Map.Make (CommandExt)
    module CSPointMap =
      Map.Make (struct
                    type t = DotsOfDice.t * RuntimeModeKind.t 
                    let compare (d1, m1) (d2, m2) =
                      let res = DotsOfDice.compare d1 d2 in
                      if res <> 0 then res else
                        RuntimeModeKindExt.compare m1 m2
                  end)

    type t = { commands : Graphics.image CommandMap.t;
                 points : Graphics.image CSPointMap.t;
                   base : Provider.t
             }
           
    type result_t = (Image.t, t) StateUpdatableResult.t

    let decorate provider =
      { commands = CommandMap.empty;
          points = CSPointMap.empty;
            base = provider 
      }
      
    module Command = struct
        let rec get command o =
          if CommandMap.mem command o.commands then
            StateUpdatableResult.(
              { result = CommandMap.find command o.commands;
                 state = o
              }) else

            let img = Provider.Command.get command o.base in
            let commands = CommandMap.add command img o.commands in
            get command { o with commands }
      end

    module CallStackPoint = struct
        let rec get dots mode o =
          let key = dots, RuntimeMode.kind_of mode in
          if CSPointMap.mem key o.points then
            StateUpdatableResult.(
              { result = CSPointMap.find key o.points;
                 state = o
              }) else

          let img = Provider.CallStackPoint.get dots mode o.base in
          let points = CSPointMap.add key img o.points in
          get dots mode { o with points }
      end
  end
