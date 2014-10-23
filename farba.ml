module Make = functor 
  (Direction : DIRECTION.T) = functor 
  (BoardLink : READONLY_LINK.T with type key_t = Direction.t) = struct
   
    type t = { place_link : Place.t BoardLink.t;
               diretion   : Direction.t;
               fill       : Fill.t
             }

    let make board_link  = { place_link = board_link;
			     direction  = Direction.default;
			     fill       = Fill.Transparent
			   }

    let place_of farba         = BoardLink.value_of farba.place_link
    let direction_of farba     = farba.direction
    let fill_of farba          = farba.fill
    let do_with farba ~command = 
      let open Command   in
      let open Direction in
      let open BoardLink in
      let { place_link; 
	    direction; 
	    fill 
	  } = farba 
      in
      match command with
      | Fill fill -> { farba with fill }
      | Turn hand -> { farba with direction = turn direction ~to':hand }
      | Replicate -> { farba with place = value_of (go_from place ~by:direction);
		                  direction = opposite direction
                     }
end


