module HexMap = Map.Make(HexCoord)
module HexSet = Set.Make(HexCoord)

type ('cytoplasm, 'nucleus, 'virus) t =
  {  cytoplasm : 'cytoplasm HexMap.t;
        nuclei : 'nucleus HexMap.t;
       viruses : 'virus HexMap.t;
    unresolved : HexSet.t
  }

let empty =
  {  cytoplasm = HexMap.empty;
        nuclei = HexMap.empty;
       viruses = HexMap.empty;
    unresolved = HexSet.empty
  }

let cytoplasm_opt i o = HexMap.find_opt i o.cytoplasm
let nucleus_opt   i o = HexMap.find_opt i o.nuclei 
let virus_opt     i o = HexMap.find_opt i o.viruses

let cytoplasm i o = HexMap.find i o.cytoplasm
let nucleus   i o = HexMap.find i o.nuclei 
let virus     i o = HexMap.find i o.viruses

let add_cytoplasm  i x o = { o with cytoplasm = HexMap.add i x o.cytoplasm  }
let add_nucleus    i x o = { o with nuclei    = HexMap.add i x o.nuclei     }
let add_virus      i x o = { o with viruses   = HexMap.add i x o.viruses    }

let remove_cytoplasm i o = { o with cytoplasm = HexMap.remove i o.cytoplasm }
let remove_nucleus   i o = { o with nuclei    = HexMap.remove i o.nuclei    }
let remove_virus     i o = { o with viruses   = HexMap.remove i o.viruses   }

let viruses predicate o = 
  let predicate _ x = predicate x in
  o.viruses |> HexMap.filter predicate 
            |> HexMap.bindings
       
let resolve   i o = { o with unresolved = o.unresolved |> HexSet.remove i }
let dissolve  i o = { o with unresolved = o.unresolved |> HexSet.add i    }          

let is_resolved o = HexSet.is_empty o.unresolved
