module IndexMap = Map.Make (Index)

type t = Nucleus.t IndexMap.t

let empty = IndexMap.empty
let get index o = 
  if IndexMap.mem index o then
     Some (IndexMap.find index o) else
     None

let set index value o = 
  match (IndexMap.mem index o), value with
  | false, None   -> o
  | false, Some x -> o |> IndexMap.add index x
  | true,  None   -> o |> IndexMap.remove index
  | true,  Some x -> o |> IndexMap.remove index
                       |> IndexMap.add index x
