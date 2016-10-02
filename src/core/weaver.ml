open Data.Shared
open Data.Tissue
open Utils

module Index = Shared.Index

type tissue = Tissue.t
type t = { tissue : tissue;
            stage : WeaverStage.t
         }

let make tissue =
  { tissue;
     stage = WeaverStage.Created
  }

let tissue o = o.tissue
let stage  o = o.stage

let turn hand o =
  let weaver  = o.tissue |> Tissue.weaver in
  let nucleus = o.tissue |> Tissue.fauna
                         |> IntPointMap.find weaver
                         |> Nucleus.turn hand in

  {  stage = WeaverStage.Turned;
    tissue = (o.tissue |> Tissue.fauna
                       |> IntPointMap.put weaver nucleus
                       |> Tissue.with_fauna) o.tissue
  }

let move o =
  
  let weaver = o.tissue |> Tissue.weaver
  and flora  = o.tissue |> Tissue.flora
  and fauna  = o.tissue |> Tissue.fauna in
  
  match IntPointMap.find weaver flora with
  | Blue
  | Gray  -> { o with stage = WeaverStage.(Moved Dummy) }
  | White -> let nucleus = IntPointMap.find weaver fauna in
             let i = Index.move nucleus.gaze weaver in

             if IntPointMap.mem i fauna then 
               let gaze' = Side.opposite nucleus.gaze in
               {   stage = WeaverStage.(Moved ToClot);
                  tissue = Tissue.with_clot i gaze' o.tissue
               } else

               let move nucleus =
                 (o.tissue |> Tissue.with_weaver i
                           |> Tissue.fauna
                           |> IntPointMap.put i nucleus
                           |> IntPointMap.remove weaver
                           |> Tissue.with_fauna) o.tissue in
 
               if IntPointMap.mem i flora then
                 let cytoplasm = IntPointMap.find i flora in
                 {  stage = WeaverStage.(Moved Success);
                   tissue = nucleus |> Nucleus.inject cytoplasm
	                           |> move
                 } else

                 {  stage = WeaverStage.(Moved Out);
                   tissue = move nucleus
                 }

let pass o =
  
  let weaver = o.tissue |> Tissue.weaver
  and fauna  = o.tissue |> Tissue.fauna
  and dummy o = { o with stage = WeaverStage.(Passed Dummy) } in

  let nucleus = IntPointMap.find weaver fauna in
  let i = Index.move nucleus.gaze weaver in

  if IntPointMap.mem i fauna then
    let acceptor = IntPointMap.find i fauna in
    if acceptor.gaze = (Side.opposite nucleus.gaze) then
      {  stage = WeaverStage.(Passed Success);
        tissue = Tissue.with_weaver i o.tissue
      }
    else dummy o
  else dummy o

let replicate relation o =
  
  let weaver = o.tissue |> Tissue.weaver
  and flora  = o.tissue |> Tissue.flora
  and fauna  = o.tissue |> Tissue.fauna in

  if IntPointMap.find weaver flora = White then
    { o with stage = WeaverStage.(Replicated Dummy)
    } else

    let nucleus = IntPointMap.find weaver fauna in
    let i = Index.move nucleus.gaze weaver in

    if IntPointMap.mem i fauna then
      let gaze' = Side.opposite nucleus.gaze in
      {  stage = WeaverStage.(Replicated ToClot);
        tissue = Tissue.with_clot i gaze' o.tissue
      } else

      let child = Nucleus.replicate relation nucleus
      and put nucleus = 
        (o.tissue |> Tissue.with_weaver i
                  |> Tissue.fauna
                  |> IntPointMap.put i nucleus
                  |> Tissue.with_fauna) o.tissue in
        
      if IntPointMap.mem i flora then
        let cytoplasm = IntPointMap.find i flora in
        {  stage = WeaverStage.(Replicated Success);
          tissue = child |> Nucleus.inject cytoplasm
                         |> put
        } else

        {  stage = WeaverStage.(Replicated Out);
          tissue = put child
        }
