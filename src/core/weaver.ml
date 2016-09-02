open Data
open Tools
open Nucleus

type tissue_t = Tissue.t
type t = {  tissue : tissue_t;
             stage : WeaverStage.t;
           counter : WeaverActsCounter.t
         }

module Counter = WeaverActsCounter
module Stage = WeaverStage
module Act = WeaverAct

let make tissue =
  {  tissue;
      stage = Stage.Created;
    counter = Counter.zero
  }

let tissue o = o.tissue
let stage  o = o.stage

let turn hand o =
  let weaver  = o.tissue |> Tissue.weaver in
  let nucleus = o.tissue |> Tissue.fauna
                         |> IntPointMap.find weaver
                         |> NucleusExt.turn hand in
  {   stage = Stage.Turned;
    counter = Counter.increment WeaverAct.Turn o.counter;
     tissue = (o.tissue |> Tissue.fauna
                        |> IntPointMap.set weaver nucleus
                        |> Tissue.with_fauna) o.tissue
  }

let move o =
  
  let weaver = o.tissue |> Tissue.weaver
  and flora  = o.tissue |> Tissue.flora
  and fauna  = o.tissue |> Tissue.fauna in
  
  match IntPointMap.find weaver flora with

  | Pigment.White ->
     let nucleus = IntPointMap.find weaver fauna in
     let i = Index.move nucleus.gaze weaver in

     if IntPointMap.mem i fauna then 
       let gaze' = SideExt.opposite nucleus.gaze in
       {   stage = Stage.(Moved ToClot);
         counter = Counter.increment Act.Move o.counter;
          tissue = Tissue.with_clot i gaze' o.tissue
       } else

       let move nucleus =
         (o.tissue |> Tissue.with_weaver i
                   |> Tissue.fauna
                   |> IntPointMap.set i nucleus
                   |> IntPointMap.remove weaver
                   |> Tissue.with_fauna) o.tissue in
 
       if IntPointMap.mem i flora then
         let cytoplasm = IntPointMap.find i flora in
         {   stage = Stage.(Moved Success);
           counter = Counter.increment Act.Move o.counter;
            tissue = nucleus |> NucleusExt.inject cytoplasm
	                     |> move
         } else

         {   stage = Stage.(Moved Out);
           counter = Counter.increment Act.Move o.counter;
            tissue = move nucleus
         }
     
  | Pigment.Blue
  | Pigment.Gray  ->
     { o with stage = Stage.(Moved Dummy);
            counter = Counter.increment Act.DummyMove o.counter;
     }

let pass o =
  
  let weaver = o.tissue |> Tissue.weaver
  and fauna  = o.tissue |> Tissue.fauna
  and dummy o =
    { o with stage = Stage.(Passed Dummy);
           counter = Counter.increment Act.DummyPass o.counter
    } in

  let nucleus = IntPointMap.find weaver fauna in
  let i = Index.move nucleus.gaze weaver in

  if IntPointMap.mem i fauna then
    let acceptor = IntPointMap.find i fauna in
    if acceptor.gaze = (SideExt.opposite nucleus.gaze) then
      {   stage = Stage.(Passed Success);
        counter = Counter.increment Act.Pass o.counter;
         tissue = Tissue.with_weaver i o.tissue
      }
    else dummy o
  else dummy o

let replicate relation o =
  
  let weaver = o.tissue |> Tissue.weaver
  and flora  = o.tissue |> Tissue.flora
  and fauna  = o.tissue |> Tissue.fauna in

  if IntPointMap.find weaver flora = Pigment.White then
    { o with stage = Stage.(Replicated Dummy);
           counter = Counter.increment Act.DummyReplicate o.counter
    } else

    let nucleus = IntPointMap.find weaver fauna in
    let i = Index.move nucleus.gaze weaver in

    if IntPointMap.mem i fauna then
      let gaze' = SideExt.opposite nucleus.gaze in
      {   stage = Stage.(Replicated ToClot);
        counter = Counter.increment Act.Replicate o.counter;
         tissue = Tissue.with_clot i gaze' o.tissue
      } else

      let child = NucleusExt.replicate relation nucleus
      and set nucleus = 
        (o.tissue |> Tissue.with_weaver i
                  |> Tissue.fauna
                  |> IntPointMap.set i nucleus
                  |> Tissue.with_fauna) o.tissue in
        
      if IntPointMap.mem i flora then
        let cytoplasm = IntPointMap.find i flora in
        {   stage = Stage.(Replicated Success);
          counter = Counter.increment Act.Replicate o.counter;
           tissue = child |> NucleusExt.inject cytoplasm
                          |> set
        } else

        {   stage = Stage.(Replicated Out);
          counter = Counter.increment Act.Replicate o.counter;
           tissue = set child
        }

let statistics o =
  let tissue = TissueCounter.calculate_for o.tissue
  and acts = Counter.calculate o.counter in
  WeaverStatistics.(
    { tissue;
      acts
    })
