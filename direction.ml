module Make : DIRECTION.MAKE_T = functor 
  (Seed : DIRECTION.SEED_T) -> struct

    open RoundelayLink
    open Hand

    type t = Seed.t

    let default =
      Seed.all_from_default_ordered_to_right
        |> Dlink.load
        |> RoundelayLink.close 

    let opposite_index = 
      let rec count current acc =
	if value_of current = 
	   value_of default && acc <> 0 then acc 
	else 
	   count (get_from current ~by:Right) 
	         (acc + 1) 
      in
      (count default 0) / 2

    let opposite direction =
      let rec opposite' current i  =
	if i = opposite_index then 
	  value_of current 
	else opposite' (go_from current ~by:Right)
	               (i + 1) 
      in
      opposite' default 0 

    let compare x y =
      let index_of direction =
	let rec index_of' current acc =
	  if direction = value_of current then acc else
	     index_of'(go_from current ~by:Right)
	              (acc + 1) 
	in 
	index_of' default 0 in
      Pervasives.compare (index_of x)
	                 (index_of y)
	  
    let turn direction ~to':hand = 
      let rec find ~current =
	if direction = value_of current then current else
	   find (go_from current ~by:Right) in
      go_from (find ~current:default)
              ~by:hand
  end


