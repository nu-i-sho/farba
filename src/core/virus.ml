type t = { program : Command.t array;
            crumbs : Breadcrumbs.t;
              cell : Cell.t;
              mode : Mode.t
	 }

let make program start_cell =
  { program;
     crumbs = Breadcrumbs.start;
       cell = start_cell;
       mode = Mode.Run
  }  

let next o =
  let i = Breadcrumbs.last_place o.crumbs in
  let command = o.program.(i) in
  let o' =
    match o.mode with
    
    | Mode.Run -> begin
	match command with
	| Command.Turn side ->
	   { o with cell = Cell.turn side o.cell }
	| Command.Replicate relation ->
	   { o with cell = Cell.replicate relation o.cell }
	| Command.Call func -> 
	   { o with mode = Mode.Find func }
	| Command.Declare _ 
	| Command.End ->
	   let crumb  = Breadcrumbs.last o.crumbs in
	   let crumb' = DotsOfDice.decrement crumb in
           { o with mode = Mode.Return crumb' }
      end

    | Mode.Find f when command == (Command.Declare f) ->
       { o with mode = Mode.Run }

    | Mode.Return c when c == (Breadcrumbs.last o.crumbs) ->
       { o with mode = Mode.Run }

    | _ -> o
  in

  let move = match o'.mode with
             | Mode.Find _
             | Mode.Run      -> Breadcrumbs.increment
             | Mode.Return _ -> Breadcrumbs.decrement
  in

  { o' with crumbs = move o'.crumbs }
