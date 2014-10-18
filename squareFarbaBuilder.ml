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
	Link.join (Link.join current 
		     ~with':up 
		        ~by:Up)
	  ~with':left 
	     ~by:Left
      in
      let rec process ~left ~up ~pos 
	  ?(farba = None) =

	let process' ~simbol:c 
	    ?(farba_finded = false) = 

	  let current = c |> Place.parse
	                  |> Link.make
			  |> combine left up 
	  and next_up = 
	    Link.go_from 
	      (Link.go_from current 
		 ~by:Up) 
	      ~by:Right 
	  in
	  let x_farba = if farba_finded then 
	    (Some (Farba.make_with ~board_link:current))
	  else farba 
	  in
	  process ~left:(current) 
	            ~up:(next_up) 
	           ~pos:(pos + 3)
	         ~farba:(x_farba)
	in
	match level.[i], 
	      level.[i + 1], 
	      level.[i + 2] with

	|  '.', chr, '.' -> process' ~simbol:chr
	|  '<', chr, '>' -> process' ~simbol:chr
	|  '[', chr, ']' -> process' ~simbol:chr ~farba_finded:true
	| '\n', ___, ___ -> process  ~pos:(i + 1)
	|  'e', 'n', 'd' -> let Some result = farba in 
	                    result
  end
