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

let acts_statistics o = 
  Counter.calculate o.counter

let inc field o = 
  { o with counter = Counter.increment field o.counter }

let turn hand o =
  { (inc WeaverAct.Turn o) with base = Weaver.turn hand o.base }

let pass o = 
  let open WeavingResult.OfPass in
  match Weaver.pass o.base with 
  | Success base -> Success { (inc WeaverAct.Pass o) with base }
  | Dummy   base -> Dummy { (inc  WeaverAct.DummyPass o) with base }

let move act success dummy o =
  let open WeavingResult.OfMove in
  match act o.base with
  | Success base -> Success { (inc success o) with base }
  | Dummy   base -> Dummy   { (inc dummy o)   with base }
  | Outed   base -> Outed   { (inc success o) with base }
  | Clot    base -> Clot    { (inc success o) with base }

let replicate relation = 
  move (Weaver.replicate relation) 
        WeaverAct.Replicate
        WeaverAct.DummyReplicate

let move = 
  move Weaver.move
       WeaverAct.Move
       WeaverAct.DummyMove
