module Make (Weaver : STATISTICABLE_WEAVER.T) = struct
    include Runtime.Make (Weaver)
        
    let statistics o =
      Data.Statistics.(
        let x = Weaver.statistics (weaver o) in
        { solution = CommandsCounter.calculate_for (solution o);
            tissue = WeaverStatistics.(x.tissue);
              acts = WeaverStatistics.(x.acts)
        })
  end
