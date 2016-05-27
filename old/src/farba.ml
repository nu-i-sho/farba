module Make  : FARBA.MAKE_T = functor 
  (Direction : DIRECTION.T) -> functor 
  (BoardLink : READONLY_LINK.T with type key_t = Direction.t) -> struct
   
    type 'a board_link_t = 'a BoardLink.t
    type direction_t = Direction.t

    type t = { place_link : Place.t board_link_t;
               direction  : direction_t;
               fill       : Fill.t
             }
	  
    let make board_link  = { place_link = board_link;
			     direction  = Direction.default;
			     fill       = Fill.empty
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
      | Replicate -> { farba with place_link = get_from place_link ~by:direction;
		                  direction = opposite direction
                     }
end


