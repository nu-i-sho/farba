module Mode = struct
    type t = | Run
             | Find
             | Return
end

module Event = struct
    type t = | ModeChanged of (Mode.t * Mode.t)
	     | Breadcrumbs of Breadcrumbs.Event.t
end

type t = { crumbs : Breadcrumbs.t;
             mode : Mode.t;
             next : (Event.t -> unit) option
	 }

let start = { crumbs = Breadcrumbs.start;
                mode = Mode.Run;
                next = None
	    }

let position_of o =
  Breadcrumbs.last_place o.crumbs 

let next event o =
  let () = match o.next with
           | Some f -> f (Lazy.force event)
           | None   -> ()
  in
  o

let starto ~observer:next = 
  let next' event = next (Event.Breadcrumbs event) in 
  { crumbs = Breadcrumbs.starto ~observer:next';
      mode = Mode.Run;
      next = Some next
  }

let set_mode m o =
  { o with mode = m }
  |> next (lazy(Event.ModeChanged (o.mode, m)))   

let step o = 
  let go = match o.mode with 
           | Mode.Run | Mode.Find -> Breadcrumbs.increment
           | Mode.Return          -> Breadcrumbs.decrement
  in

  { o with crumbs = go o.crumbs }
