module HexMap = Map.Make (HexCoord)

type t = {  nucleuses : Nucleus.t HexMap.t;
           cytoplasms : Pigment.t HexMap.t;
                 clot : HexCoord.t option
         }
       
let empty =
  {  nucleuses = HexMap.empty;
    cytoplasms = HexMap.empty;
          clot = None
  }
    
let is_in     i o = HexMap.mem i o.cytoplasms
let is_out_of i o = not (is_in i o)
   
let clot_opt o = o.clot
let has_clot o = 
  match o.clot with
  | Some _ -> true
  | None   -> false

let clot o =
  match o.clot with
  | Some x -> x
  | None   -> assert false

let set_clot  i o = { o with clot = Some i }
let remove_clot o = { o with clot = None   }
  
let cytoplasm     i o = o.cytoplasms |> HexMap.find i 
let cytoplasm_opt i o = o.cytoplasms |> HexMap.find_opt i
let cytoplasms      o = o.cytoplasms |> HexMap.to_seq

let add_cytoplasm i x o =
  let c = HexMap.set i x o.cytoplasms in
  { o with cytoplasms = c
  }

let remove_cytoplasm i o =
  let c = HexMap.remove i o.cytoplasms in
  { o with cytoplasms = c
  }
   
let nucleus     i o = o.nucleuses |> HexMap.find i
let nucleus_opt i o = o.nucleuses |> HexMap.find_opt i
let nucleuses     o = o.nucleuses |> HexMap.to_seq 

let set_nucleus i x o =
  let n = HexMap.set i x o.nucleuses in 
  { o with nucleuses = n 
  }

let remove_nucleus i o =
  let n = HexMap.remove i o.nucleuses in
  { o with nucleuses = n
  }
