module Make : OBSERVABLE.T = struct 
  
  module M = Map.Make (struct
    type t = int
    let compare = Pervasives.compare
  end)

  type 'a t = { map : 'a M.t;
		max : int
	      }

  let subscribe observer o = 
    let max = o.max + 1 in
    let o = { o with map = o.map |> Map.add max observer; max } in
    let unsibscribe () =
      let o = { o with map = o.map |> Map.remove max observer } in
      (observer, o) in
    unsubscribe
end
