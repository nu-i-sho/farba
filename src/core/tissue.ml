module IndexMap = Map.Make (Index)

type t = TissueItem.t IndexMap.t

let empty = IndexMap.empty
let get i o = 
  if IndexMap.mem i o then
     IndexMap.find i o else
     TissueItem.None

let set i v o = 
  match (IndexMap.mem i o), (v = TissueItem.None) with
  | false, true  -> o
  | false, false -> o |> IndexMap.add i v
  | true,  true  -> o |> IndexMap.remove i
  | true,  false -> o |> IndexMap.remove i 
                      |> IndexMap.add i v
