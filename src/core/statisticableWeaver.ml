module Counter = WeaverActsCounter
type t = {    base : Weaver.t;
           counter : Counter.t
	 }

let extend weaver = 
  {    base = weaver;
    counter = Counter.zero
  }

let tissue o = 
  Weaver.tissue o.base

let statistics o = 
  Data.Statistics.(
    { tissue = TissueCounter.calculate_for (tissue o);
        acts = Counter.calculate o.counter
    })

let inc field o = 
  { o with counter = Counter.increment field o.counter }

let turn hand o =
  { (inc WeaverAct.Turn o) with base = Weaver.turn hand o.base }

let pass o =
  let base = Weaver.pass o.base
  and with_statistics x =
    Statused.(
      { ( match x.status with 
          | PassStatus.Success -> (inc WeaverAct.Pass o)
          | PassStatus.Dummy   -> (inc WeaverAct.DummyPass o)
        ) with base = x.value
      }
    ) in Statused.map with_statistics base
  
let statisticable_move act success dummy o =
  let with_statistics x =
    Statused.(
      { ( match x.status with
          | MoveStatus.Success 
          | MoveStatus.Outed   
          | MoveStatus.Clot  -> (inc success o)
          | MoveStatus.Dummy -> (inc dummy o)
        ) with base = x.value
      }
    ) in (act o.base) |> Statused.map with_statistics   

let replicate relation = 
  statisticable_move
    (Weaver.replicate relation) 
     WeaverAct.Replicate
     WeaverAct.DummyReplicate
  
let move = 
  statisticable_move
    Weaver.move
    WeaverAct.Move
    WeaverAct.DummyMove
