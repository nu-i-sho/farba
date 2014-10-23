module Link = InteroppositionLink.Make (SquareDirection)
include Farba.Make (SquareDirection) (Link)
type source_t = string

let parse level = 
  let open SquareDirection in	
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
  let parse_cell = Link.make @@ Place.parse in 
  let rec process ~left ~up ~coords:(i, x, y)   
      ?(farba_coords = (0, 0)) =
	
    let open Link in
    let process' current 
	?(farba_finded = false) =

      process   ~left:(Some (combine left up current)) 
	          ~up:(match up with
		       | Some u -> Some (get_from u ~by:Right)
		       | None   -> None)
              ~coords:(i + 3, y, x + 1)
	    ~farba_coords:(if farba_finded then (x, y) else farba_coords)
    in
    match level.[i], 
          level.[i + 1], 
	  level.[i + 2] with

    | '.', chr, '.' -> process' (parse_cell chr)
    | '<', chr, '>' -> process' (parse_cell chr)
    | '[', chr, ']' -> process' (parse_cell chr) ~farba_finded:true
    | '-', '-', '-' -> process' (Link.make Place.Empty)

    | '\n', _, _    -> 
	process ~left:(None)
                  ~up:(Some (go_to_end_from current ~by:Left))
	      ~coords:(i + 1, y + 1, 0)
	                       
    | 'e', 'n', 'd' -> 
	let close start ~dir ~steps_count:i =
	  let left_side = turn dir ~to':Hand.Left in
	  let rec close' current dir i =
	    if i = 0 
	    then current 
	    else current |> go_to_end_from ~by:dir
	                 |> join ~with':current ~by:dir
	                 |> shift get_from ~by:left_side
	                 |> close'(opposite dir)(i - 1)
	  in 
	  close' dir i start
	in
	let Some current = up in
	let width  = (len_to_end_of current ~by:Right) + 1 in
	let height = y in
	let (x, y) = 
	  match width mod 2, height mod 2 with
	  (* OO0 *) | 0, 0             -> (height - 1, width - 1)
          (* OOO 0OO *) | 0, 1         -> (height - 1, 0)
          (* OOO OOO OOO *) | 1, 0     -> (height - 2, width - 1)
	      (* OOO OO0 OOO *) | 1, 1 -> (height - 2, 0)
		  (* OOO 0OO *)
                      (* OOO *)
	in 
	let (fx, fy) = farba_coords      in
	let (dx, dy) = (x - fx, y - fy)  in
	let vrtcl_dir = 
          (* vertical moving direction   *) 
	  if dy < 0 then Down else Up    in
	let hrzntl_dir = 
	  (* horizontal moving direction *)
	  if dx < 0 then Right else Left in
	let (dx', dy') = (abs dx, abs dy)
	in
	current |> close ~dir:Up ~steps_count:width
	        |> close ~dir:Left ~steps_count:height
		|> go_from ~by:vrtcl_dir ~steps_count:dy'
		|> go_from ~by:hrzntl_dir ~steps_count:dx'
	        |> make
  in 
  process ~left:None 
	    ~up:None
	~coords:(0, 0, 0)
