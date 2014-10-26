module Make : DIRECTION.MAKE_T = functor 
  (Seed : DIRECTION_SEED.T) -> struct

    open RoundelayLink
    open Hand

    type t = Seed.t

    let start =
      Seed.all_from_default_ordered_to_right
        |> Dlink.load
        |> RoundelayLink.close 

    let default =
      value_of start

    let median = 
      let rec count current acc =
	if value_of current = default 
	    && acc <> 0 then acc 
	else count (get_from current ~by:Right) 
	           (acc + 1) 
      in
      (count start 0) / 2

    let find_link_with_value x =
      find_link_in start 
	~with_value:x 
	~by:Right 

   (* let opposite = value_of 
        @@ (go_from ~by:Right ~steps_count:median) 
        @@ find_link_with_value 
    *)

    let opposite direction = 
      direction |> find_link_with_value
                |> go_from ~by:Right ~steps_count:median
		|> value_of 
   
    let compare x y =
      let index_of direction =
	find_index_of_link_with 
	  ~value:direction 
	  ~in':start 
	  ~by:Right 
      in 
      Pervasives.compare 
	(index_of x)
	(index_of y)
	  
    let turn direction ~to':hand_side =
      value_of (get_from (find_link_with_value direction)
		         ~by:hand_side)
  end


