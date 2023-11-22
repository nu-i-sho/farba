module Make = functor (Seed : LAYER.SEED.T) -> struct 
  module HexMap = Map.Make(HexCoord)

  type cytoplasm_t = Seed.cytoplasm_t
  type nucleus_t = Seed.nucleus_t
    
  type t =
    { cytoplasm : Seed.cytoplasm_t HexMap.t;
         nuclei : Seed.nucleus_t HexMap.t;
    }

  let cytoplasm_opt i o = HexMap.find_opt i o.cytoplasm
  let nucleus_opt   i o = HexMap.find_opt i o.nuclei 
  let cytoplasm     i o = HexMap.find i o.cytoplasm
  let nucleus       i o = HexMap.find i o.nuclei 

  let add_cytoplasm  i x o = { o with cytoplasm = HexMap.add  i x o.cytoplasm }
  let add_nucleus    i x o = { o with nuclei    = HexMap.add  i x o.nuclei    }
  let remove_cytoplasm i o = { o with cytoplasm = HexMap.remove i o.cytoplasm }
  let remove_nucleus   i o = { o with nuclei    = HexMap.remove i o.nuclei    }
  end
