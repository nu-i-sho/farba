type t = Tissue.t
module IMap = Index.Map

let make tissue = tissue
let tissue o = o
let index = Tissue.weaver

let turn hand o =
  let nucleus = o |> Tissue.fauna
	          |> IMap.find (Tissue.weaver o)
                  |> Nucleus.turn hand in
  (o |> Tissue.fauna 
     |> IMap.set (Tissue.weaver o) nucleus
     |> Tissue.with_fauna) o

let move o =
  Data.Nucleus.(
    match IMap.find (Tissue.weaver o) (Tissue.flora o) with

    | Data.Pigment.White ->
       
       let nucleus = IMap.find (Tissue.weaver o) (Tissue.fauna o) in
       let i = Index.move nucleus.gaze (Tissue.weaver o) in

       if IMap.mem i (Tissue.fauna o) then 
	 let gaze' = Side.opposite nucleus.gaze in
         Statused.({ status = MoveStatus.Clot;
                      value = Tissue.with_clot i gaze' o
                  }) else

	 let move nucleus = (o |> Tissue.with_weaver i
                               |> Tissue.fauna
                               |> IMap.set i nucleus
                               |> IMap.remove (Tissue.weaver o)
                               |> Tissue.with_fauna) o in
 
	 if IMap.mem i (Tissue.flora o) then
	   let cytoplasm = IMap.find i (Tissue.flora o) in 
           Statused.({ status = MoveStatus.Success;
                        value = nucleus |> Nucleus.inject cytoplasm
	                                |> move
                    }) else
           Statused.({ status = MoveStatus.Outed;
                        value = nucleus |> move
                    })
 
    | Data.Pigment.Blue
    | Data.Pigment.Gray  -> 
       Statused.({ status = MoveStatus.Dummy;
                    value = o
                })
  )
 
let pass o =
  Data.Nucleus.(
    let dummy weaver =
      Statused.({ status = PassStatus.Dummy;
                   value = weaver
               }) in
    
    let nucleus = IMap.find (Tissue.weaver o) (Tissue.fauna o) in
    let i = Index.move nucleus.gaze (Tissue.weaver o) in
    if IMap.mem i (Tissue.fauna o) then
      let acceptor = IMap.find i (Tissue.fauna o) in
      if acceptor.gaze = (Side.opposite nucleus.gaze) then
	Statused.({ status = PassStatus.Success;
                     value = Tissue.with_weaver i o
                 }) else
	dummy o else
      dummy o
  )

let replicate relation o =
  Data.Nucleus.(
    if (IMap.find (Tissue.weaver o) (Tissue.flora o)) = 
	 Data.Pigment.White then
      Statused.({ status = MoveStatus.Dummy;
                   value = o
               }) else 

      let nucleus = IMap.find (Tissue.weaver o) (Tissue.fauna o) in
      let i = Index.move nucleus.gaze (Tissue.weaver o) in
      
      if IMap.mem i (Tissue.fauna o) then
	let gaze' = Side.opposite nucleus.gaze in
        Statused.({ status = MoveStatus.Clot;
                     value = Tissue.with_clot i gaze' o
                 }) else

	let child = Nucleus.replicate relation nucleus
	and set nucleus = 
	  (o |> Tissue.with_weaver i
	     |> Tissue.fauna
             |> IMap.set i nucleus
             |> Tissue.with_fauna) o in
        
	if IMap.mem i (Tissue.flora o) then
          let cytoplasm = IMap.find i (Tissue.flora o) in
	  Statused.({ status = MoveStatus.Success;
                       value = set (Nucleus.inject cytoplasm child)
                   }) else
	  Statused.({ status = MoveStatus.Outed;
                       value = set child
                   })
  )
