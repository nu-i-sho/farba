module Make : ONSERVABLE.MAKE_T = struct 
      type subscribtion_t = int
      module M = Map.Make (struct
	type t =  subscribtion_t
	let compare = Pervasives.compare
      end)

      type 'a t = { map : 'a M.t;
		    max : subscribtion_t
		  }

      type subscribtion_t = int

      val subscribe observer o = 
	let max = o.max + 1 in
	let o = { o with map = o.map |> Map.add max observer; max } in
	let unsibscribe () =
	  let o = { o with map = o.map |> Map.remove max observer } in
	  (observer, o) in
	unsubscribe
    end
