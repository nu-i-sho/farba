module Extend (Runtime : RUNTIME.T) = struct

    module Mode = RuntimeMode
    module Counter = RuntimeCounter

    type counter_t = Counter.t
    type t = {    base : Runtime.t;
               counter : counter_t
	     }
    
    let with_mode m o = 
      { o with base = Runtime.with_mode m o.base }

    let mode_of o = 
      Runtime.mode_of o.base

    let active_command o =
      Runtime.active_command o.base

    let counter_of o =
      o.counter

    let tick o =
      { o with base = Runtime.tick o.base;
            counter = ( match mode_of o with
			| Mode.Run      -> Counter.inc_runs
			| Mode.Find _   -> Counter.inc_finds
			| Mode.Return _ -> Counter.inc_returns
		      ) o.counter
      }

    let make ~base:runtime =
      {    base = runtime;
        counter = Counter.zero
      }
 
  end
