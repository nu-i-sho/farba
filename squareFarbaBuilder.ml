module Make = functor 
  (Farba : FARBA.T) = struct

    type farba_t  = Farba.t
    type source_t = string

    let parse level = 

      let module Link = 
	InteroppositionLink.Make 
	  (SquareDirection) 
      in
      let module Farba =
	Farba.Make
	  (SquareDirection)
	  (Link)
      in

      let open Hand in

      let combine left up current =
	let open Link in
	match left, up with
	| None  , None   -> current
	| None  , Some u -> join current ~with':u ~by:Up
	| Some l, None   -> join current ~with':l ~by:Left
	| Some l, Some u -> join (join current 
				    ~with':u ~by:Up)
	                      ~with':l ~by:Left
      in
      let rec process ~left ~up ~pos
	  ~current_coords: (x, y)   
	  ?(farba_coords = (0, 0)) =

	let parse = Link.make @@ Place.parse in  
	let process' current
	    ?(farba_finded = false) =

	  let current = combine left up current in
	  let next_up = 
	    Link.go_from 
	      (Link.go_from current 
		 ~by:Up) 
	      ~by:Right 
	  in
	  process     ~left:(current) 
	                ~up:(next_up)
	               ~pos:(pos + 3)
            ~current_coords:(y,x + 1)
	      ~farba_coords:(if farba_finded 
                             then current_coords
	                     else farba_coords)
	in
	match level.[pos    ], 
	      level.[pos + 1], 
	      level.[pos + 2] with

	| '-', '-', '-' -> 
	| '.', chr, '.' -> process' (parse chr)
	| '<', chr, '>' -> process' (parse chr)
	| '[', chr, ']' -> process' (parse chr) ~farba_finded:true

	| '\n',_,_      -> 
	    process      ~left:(Place.Empty)
         	           ~up:(Place.Empty)
	                  ~pos:(pos + 1) 
	       ~current_coords:(y + 1,0)

	| 'e', 'n', 'd' -> 
	    let rec go_from link ~by:direction ~pos =
	      if i = 0 then link 
	      else go_from ~current:(Link.go_from link ~by:direction)
      		               ~pos:(pos - 1)
	    in
	    Farba.make_with ~board_link:
	      (go_from (go_from 
	      

	    
  end