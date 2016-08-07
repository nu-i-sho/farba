type t = Tissue.t
module IMap = Index.Map

let make   o = o
let tissue o = o

let index = 
  Tissue.weaver

let turn hand o =
  let nucleus = o |> Tissue.fauna
	          |> IMap.find (Tissue.weaver o)
                  |> Nucleus.turn hand in
  (o |> Tissue.fauna 
     |> IMap.set (Tissue.weaver o) nucleus
     |> Tissue.with_fauna) o

let move o =
  WeavingResult.OfMove.( Data.Nucleus.(
    match IMap.find (Tissue.weaver o) (Tissue.flora o) with

    | Data.Pigment.White ->
       
       let nucleus = IMap.find (Tissue.weaver o) (Tissue.fauna o) in
       let i = Index.move nucleus.gaze (Tissue.weaver o) in

       if IMap.mem i (Tissue.fauna o) then 
	 let gaze' = Side.opposite nucleus.gaze in
	 Clot (Tissue.with_clot i gaze' o) else

	 let move nucleus = (o |> Tissue.with_weaver i
                               |> Tissue.fauna
                               |> IMap.set i nucleus
                               |> IMap.remove (Tissue.weaver o)
                               |> Tissue.with_fauna) o in
 
	 if IMap.mem i (Tissue.flora o) then
	   let cytoplasm = IMap.find i (Tissue.flora o) in 
	   Success (nucleus |> Nucleus.inject cytoplasm
	                    |> move) else
	   Outed   (nucleus |> move)
	    
    | Data.Pigment.Blue
    | Data.Pigment.Gray  -> 
       Dummy o
  ))
 
let pass o =
  WeavingResult.OfPass.( Data.Nucleus.(
    let nucleus = IMap.find (Tissue.weaver o) (Tissue.fauna o) in
    let i = Index.move nucleus.gaze (Tissue.weaver o) in
    if IMap.mem i (Tissue.fauna o) then
      let acceptor = IMap.find i (Tissue.fauna o) in
      if acceptor.gaze = (Side.opposite nucleus.gaze) then
	Success (Tissue.with_weaver i o) else
	Dummy o else
      Dummy o
  ))

let replicate relation o =
  WeavingResult.OfMove.( Data.Nucleus.(
    if (IMap.find (Tissue.weaver o) (Tissue.flora o)) = 
	 Data.Pigment.White then
      Dummy o else 

      let nucleus = IMap.find (Tissue.weaver o) (Tissue.fauna o) in
      let i = Index.move nucleus.gaze (Tissue.weaver o) in
      
      if IMap.mem i (Tissue.fauna o) then
	let gaze' = Side.opposite nucleus.gaze in
	Clot (Tissue.with_clot i gaze' o) else 
	  
	let child = Nucleus.replicate relation nucleus
	and set nucleus = 
	  (o |> Tissue.with_weaver i
	     |> Tissue.fauna
             |> IMap.set i nucleus
             |> Tissue.with_fauna) o in

	if IMap.mem i (Tissue.flora o) then
	  let cytoplasm = IMap.find i (Tissue.flora o) in
	  let child = Nucleus.inject cytoplasm child in
	  Success (set child) else
	  Outed   (set child)
  ))
