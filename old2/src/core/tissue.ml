module IndexMap = Map.Make (Index)

type t = Shared.TissueItem.t IndexMap.t

let empty = IndexMap.empty
let mem   = IndexMap.mem
let get   = IndexMap.find

let set i v o = 
  if mem i o then o.tissue |> IndexMap.remove i 
			   |> IndexMap.add i v
	     else o.tissue |> IndexMap.add i v
