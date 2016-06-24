module Make (Crumbs : BREADCRUMBS.T) 
              (Cell : TISSUE_CELL.T) = struct

    module Counter = LifeCounter

    type t = {  program : Program.t;
                 crumbs : Crumbs.t;
                  owner : Cell.t;
                   mode : Mode.t;
                counter : Counter.t
 	     }

    type life_moment_t = | Instant of t
                         | End of Counter.t

    let make  ~program: p
             ~infected: owner
          ~breadcrumbs: crumbs = 
      
      {  program = p;
	  crumbs;
	   owner;
	    mode = Mode.Run;
	 counter = Counter.zero
      }				  

    let act command o =
      let open Command in
      match command with

      | Turn hand -> 
	 { o with owner = Cell.turn hand o.owner; 
	        counter = Counter.inc_turns o.counter	       
	 }

      | Replicate relation ->
	 { o with owner = Cell.replicate relation o.owner;
                counter = Counter.inc_replications o.counter
	 }

      | Call func ->
	 { o with crumbs = Crumbs.split o.crumbs;
	            mode = Mode.Find func;
	 }

      | Declare _ 
      | End ->
	 let crumb  = Crumbs.last o.crumbs in
         let crumb' = DotsOfDice.decrement crumb in
	 { o with mode = Mode.Return crumb' }

    let move o =
      match o.mode with

      | Mode.Run      -> 	 
	 { o with crumbs = Crumbs.increment o.crumbs;
                 counter = Counter.inc_crumbs_steps_of_run 
			     o.counter
	 }

      | Mode.Find _   ->  
	 { o with crumbs = Crumbs.increment o.crumbs;
                 counter = Counter.inc_crumbs_steps_of_find 
			     o.counter
	 }

      | Mode.Return _ -> 
	 { o with crumbs = Crumbs.decrement o.crumbs;
                 counter = Counter.inc_crumbs_steps_of_return 
			     o.counter
	 }

    let tick o =
      let open CellKind in
      match Cell.kind_of o.owner with
      | _ when (Crumbs.is_empty o.crumbs) || 
	       (Cell.is_out o.owner) -> End o.counter
      | Clot                         -> End o.counter
      | Hels | Cancer                ->

	 let i = Crumbs.last_place o.crumbs in
	 let cmd = Program.get i o.program in
	 let open Mode in
         Instant (( match o.mode with
		    | Run -> act cmd o  
		    | Find f when cmd = (Command.Declare f) ->
		       { o with mode = Run }
	            | Return crumb 
			 when crumb = (Crumbs.last o.crumbs) ->
		       { o with mode = Run }
	            | _ -> o
	          ) |> move
		 )

    let rec run o =
      match tick o with
      | Instant o   -> run o
      | End counter -> counter 

  end
