module Mode = struct
    type t = | Run
	     | Find of DotsOfDice.t
	     | Return of DotsOfDice.t
  end

type t = {    mode : Mode.t;
           program : Program.t;
            crumbs : Breadcrumbs.t
	 }

let make ~breadcrumbs:b 
             ~program:p = {    mode = Mode.Run;
                            program = p;
                             crumbs = b
			  }

let with_mode m o = { o with mode = m }
let mode_of o = o.mode 

let active_command o =
  let i = Breadcrumbs.last_place o.crumbs in
  Program.get i o.program

let tick o =
  let move = match o.mode with
             | Mode.Run 
	     | Mode.Find _   -> Breadcrumbs.increment
	     | Mode.Return _ -> Breadcrumbs.decrement
  in
  { o with crumbs = move o.crumbs }
