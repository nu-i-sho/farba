module State = struct
    type t = | Run
             | Scroll
  end

type 'a t = { active : 'a;
              hidden : 'a option;
               state : State.t;
            }

let make value =
  { active = value;
    hidden = None;
     state = State.Run
  }
  
let value o =
  o.active

let with_value x o =
  { o with value = x }

let swap_to_run o =
  match o.state with
  | State.Run    -> o
  | State.Scroll -> { o with state = State.Run;
                            hidden = None;
                            active = o.hidden
                    }

let swap_to_scroll o =
  match o.state with
  | State.Scroll -> o
  | State.Run    -> { o with state = State.Scroll;
                            hidden = o.active;
                            active = match o.hidden with
                                     | None   -> o.active
                                     | Some x -> x
                    }
