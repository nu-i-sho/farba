module Make (Breadcrumbs : BREADCRUMBS.T)
                (Program : PROGRAM.T) = struct

    type t = {    mode : RuntimeMode.t;
	       program : Program.t;
                crumbs : Breadcrumbs.t
	     }

    let make ~breadcrumbs:b 
                 ~program:p = {    mode = RuntimeMode.Run;
				program = p;
                                 crumbs = b
			      }

    let with_mode m o = { o with mode = m }
    let mode_of o = o.mode 

    let active_command o =
      let i = Breadcrumbs.last_place o.crumbs in
      Program.get i o.program

    let tick o =
      let move = 
	let open RuntimeMode in
	match o.mode with
        | Run 
	| Find _   -> Breadcrumbs.increment
	| Return _ -> Breadcrumbs.decrement
      in
      { o with crumbs = move o.crumbs }
  end
