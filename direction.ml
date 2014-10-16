module Make (Seed : DIRECTION_SEED) = struct
  open Hand

  type t = Seed.t

  let default =
    RoundelayLink.close 
      (Dlink.load_from 
	 Seed.all_from_default_ordered_to_right) 

  let opposite_index = 
    let rec count current acc =
      if current = Dlink.value_of default && acc <> 0
      then acc
      else count 
	  (Dlink.go_from current ~by:Righ) 
	  (acc + 1) 
    in
    (count default 0) / 2

  let opposite direction =
    let rec opposite' current i  =
      if i = opposite_index
      then Dlink.value_of current
      else opposite' 
	  (Dlink.go_from current ~by:Right)
	  (i + 1)	    
    in
    opposite' default 0 

  let compare x y =
    let index_of direction =
      let rec index_of' current acc =
	if direction = Dlink.value_of current
	then acc 
	else index_of'
	    (Dlink.go_from current ~by:Right)
	    (acc + 1) 
      in 
      index_of' default 0 in
    Pervasives.compare
      (index_of x)
      (index_of y)
	  
  let turn direction ~to':hand = 
    let rec find ~current =
      if direction = Dlink.value_of current
      then current
      else find (Dlink.go_from current ~by:Right)
    in
    Dlink.go_from
      (find ~current:default)
      ~by:hand
end
