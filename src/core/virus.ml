module Make (Crumbs : BREADCRUMBS.T) 
              (Cell : TISSUE_CELL.T) = struct

    type t = { program : Program.t;
                crumbs : Crumbs.t;
                 owner : Cell.t;
                  mode : Mode.t
	     }

    let make  ~program: p
             ~infected: owner
          ~breadcrumbs: crumbs = {  program = p;
	 			     crumbs;
				      owner;
				       mode = Mode.Run
				 }  
    let act command o = 
      Command.(
	match command with
	| Turn hand ->
	   { o with owner = Cell.turn hand o.owner }
	| Replicate relation ->
	   { o with owner = Cell.replicate relation o.owner }
	| Call func -> 
	   { o with mode = Mode.Find func }
	| Declare _ 
	| End ->
	   let crumb  = Crumbs.last o.crumbs in
           let crumb' = DotsOfDice.decrement crumb in
	   { o with mode = Mode.Return crumb' }
  ) 

    let move o =
      let move = match o.mode with
	         | Mode.Find _
	         | Mode.Run      -> Crumbs.increment
	         | Mode.Return _ -> Crumbs.decrement
      in
  
      { o with crumbs = move o.crumbs}

    let next o =
      let open CellKind in
      match Cell.kind_of o.owner with
      | _ when (Crumbs.is_empty o.crumbs) || 
	       (Cell.is_out o.owner) -> None
      | Clot                         -> None
      | Hels | Cancer                ->

	 let i = Crumbs.last_place o.crumbs in
	 let cmd = Program.get i o.program in
	 Some ( Mode.( match o.mode with
	               | Run -> act cmd o
	               | Find f 
			    when cmd = (Command.Declare f) -> 
			  { o with mode = Run }
	               | Return c 
			    when c = (Crumbs.last o.crumbs) ->
			  { o with mode = Run }
	               | _ -> o
	             ) |> move
	      )

    let rec run o =
      match next o with
      | Some o -> run o
      | None -> () 

  end
