module Make (Colony : COLONY.T) = struct
    
    module PigmentMap = Map.Make (Pigment)
    open Data.Pigment

    type t = int PigmentMap.t 
	   
    let calculate colony =
      let height = Colony.height colony
      and width  = Colony.width  colony in
      let rec calc x y none blue gray =
	if y = height 
	then PigmentMap.empty |> PigmentMap.add None none
                              |> PigmentMap.add Blue blue
                              |> PigmentMap.add Gray gray 
	else if x = width 
	then calc 0 (y + 1) none blue gray
	else match Colony.get (x, y) colony with
	     | None -> calc (x + 1) y (none + 1) blue gray
	     | Blue -> calc (x + 1) y none (blue + 1) gray
	     | Gray -> calc (x + 1) y none blue (gray + 1)
      in

      calc 0 0 0 0 0

    let count_of = PigmentMap.find 
    let count o  = (count_of None o)
                 + (count_of Blue o)
                 + (count_of Gray o)
  end
