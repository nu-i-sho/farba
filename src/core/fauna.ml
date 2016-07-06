module IndexMap = Map.Make (Index)

type e = Nucleus.t option
type t = { storage = Nucleus.t IndexMap.t;
            height = int;
             width = int;
	 }

let load ~height:h 
          ~width:w 
         ~source:s = { storage = s;
		        height = h;
		         width = w;
		     }

let height o = o.height
let width  o = o.width

let set i value o =  
  { o with storage = 
	     match (IndexMap.mem i o.storage), value with
             | false, None   -> o.storage
	     | false, Some x -> o.storage |> IndexMap.add i x
	     | true,  None   -> o.storage |> IndexMap.remove i
	     | true,  Some x -> o.storage |> IndexMap.remove i
                                          |> IndexMap.add i x 
  }

let get i o = 
  if IndexMap.mem i o.storage then
     Some (IndexMap.find i o.storage) else
     None
