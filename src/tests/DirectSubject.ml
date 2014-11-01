module M = Map.Make (struct
  type t = int
  let compare = Pervasives.compare
end)

type 'a t = 
    { map : 'a M.t;
      max : int
    }

let empty =
  { map = M.empty;
    max = 0
  }

let send msg o =
  let send _ observer = observer msg in
  let _ = o.map |> Map.iter send in
  o

let subscribe observer o = 
  let max = o.max + 1 in
  let o = { o with map = o.map |> Map.add max observer; max } in
  let unsibscribe () =
    let o = { o with map = o.map |> Map.remove max observer } in
    (observer, o) in
  (unsubscribe, o)
