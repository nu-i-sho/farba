type t = Tissue.t

open Data
open Tools
open Nucleus
   
let make tissue = tissue
let tissue o = o
let index = Tissue.weaver

let turn hand o =
  let weaver  = o |> Tissue.weaver in
  let nucleus = o |> Tissue.fauna
	          |> IntPointMap.find weaver
                  |> NucleusExt.turn hand in
  (o |> Tissue.fauna 
     |> IntPointMap.set weaver nucleus
     |> Tissue.with_fauna) o

let move o =
    
  let weaver = Tissue.weaver o
  and flora  = Tissue.flora  o
  and fauna  = Tissue.fauna  o in
 
  match IntPointMap.find weaver flora with

  | Pigment.White ->
       
     let nucleus = IntPointMap.find weaver fauna in
     let i = Index.move nucleus.gaze weaver in

     if IntPointMap.mem i fauna then 
       let gaze' = SideExt.opposite nucleus.gaze in
       Statused.({ status = MoveStatus.Clot;
                    value = Tissue.with_clot i gaze' o
                }) else

       let move nucleus = (o |> Tissue.with_weaver i
                             |> Tissue.fauna
                             |> IntPointMap.set i nucleus
                             |> IntPointMap.remove weaver
                             |> Tissue.with_fauna) o in
 
       if IntPointMap.mem i flora then
	 let cytoplasm = IntPointMap.find i flora in 
         Statused.({ status = MoveStatus.Success;
                      value = nucleus |> NucleusExt.inject cytoplasm
	                              |> move
                  }) else
         Statused.({ status = MoveStatus.Outed;
                      value = nucleus |> move
                  })
 
  | Pigment.Blue
  | Pigment.Gray  -> 
     Statused.({ status = MoveStatus.Dummy;
                  value = o
              })
    
let pass o =
  let weaver = Tissue.weaver o
  and fauna  = Tissue.fauna  o
  and dummy weaver =
    Statused.({ status = PassStatus.Dummy;
                 value = weaver
             }) in
  
  let nucleus = IntPointMap.find weaver fauna in
  let i = Index.move nucleus.gaze weaver in
  if IntPointMap.mem i fauna then
    let acceptor = IntPointMap.find i fauna in
    if acceptor.gaze = (SideExt.opposite nucleus.gaze) then
      Statused.({ status = PassStatus.Success;
                   value = Tissue.with_weaver i o
               }) else
      dummy o else
    dummy o

let replicate relation o =
  
  let weaver = Tissue.weaver o
  and flora  = Tissue.flora  o
  and fauna  = Tissue.fauna  o in
  
  if IntPointMap.find weaver flora = Pigment.White then
    Statused.({ status = MoveStatus.Dummy;
                 value = o
             }) else 

    let nucleus = IntPointMap.find weaver fauna in
    let i = Index.move nucleus.gaze weaver in
      
    if IntPointMap.mem i fauna then
      let gaze' = SideExt.opposite nucleus.gaze in
      Statused.({ status = MoveStatus.Clot;
                   value = Tissue.with_clot i gaze' o
               }) else

      let child = NucleusExt.replicate relation nucleus
      and set nucleus = 
	(o |> Tissue.with_weaver i
	   |> Tissue.fauna
           |> IntPointMap.set i nucleus
           |> Tissue.with_fauna) o in
        
      if IntPointMap.mem i flora then
        let cytoplasm = IntPointMap.find i flora in
	Statused.({ status = MoveStatus.Success;
                     value = set (NucleusExt.inject cytoplasm child)
                 }) else
	Statused.({ status = MoveStatus.Outed;
                     value = set child
                 })
