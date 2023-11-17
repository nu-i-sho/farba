module Area = struct
  type ('c, 'n, 'v) t =
    { cytoplasms : 'c HexMap.t;
          nuclei : 'n HexMap.t;
         viruses : 'v HexMap.t
    }

  let empty =
    { cytoplasms = HexMap.empty;
          nuclei = HexMap.empty;
         viruses = HexMap.empty
    }

  let is_empty o =
    (o.cytoplasms |> HexMap.is_empty) &&
        (o.nuclei |> HexMap.is_empty) &&
       (o.viruses |> HexMap.is_empty)
    
  module Get = struct
    let cytoplasms o = o.cytoplasms
    let nuclei     o = o.nuclei
    let viruses    o = o.viruses
    end

  module Map = struct
    let cytoplasms f o = { o with cytoplasms = f o.cytoplasms }
    let nuclei     f o = { o with     nuclei = f o.nuclei     }
    let viruses    f o = { o with    viruses = f o.viruses    }
    end
  end

type ('cytoplasm, 'nucleus, 'virus) t =
  { problems : ('cytoplasm, 'nucleus, 'virus) Area.t;
    resolved : ('cytoplasm, 'nucleus, 'virus) Area.t
  }
  
let empty =
  { problems = Area.empty;
    resolved = Area.empty
  }

module Get = struct
  let problems o = o.problems
  let resolved o = o.resolved
end

module Map = struct
  let problems f o = { o with problems = f o.problems }
  let resolved f o = { o with resolved = f o.resolved }
end
                   
let find_opt get_layer i o =
  match        o |> Get.problems
                 |> get_layer
                 |> HexMap.find_opt i with
  | None    -> o |> Get.resolved
                 |> get_layer
                 |> HexMap.find_opt i
  | x       -> x

let find get_layer i o =
  match        o |> Get.problems
                 |> get_layer
                 |> HexMap.find_opt i with
  | None    -> o |> Get.resolved
                 |> get_layer
                 |> HexMap.find i
  | Some x  -> x                  

let add map_layer i x o =
  { resolved = o |> Get.resolved
                 |> map_layer (HexMap.remove i);
    problems = o |> Get.problems
                 |> map_layer (HexMap.add i x)
  }

let remove map_layer i o =
  { resolved = o |> Get.resolved
                 |> map_layer (HexMap.remove i);
    problems = o |> Get.problems
                 |> map_layer (HexMap.remove i)
  }
  
let cytoplasm_opt i o = find_opt Area.Get.cytoplasms i o
let nucleus_opt   i o = find_opt Area.Get.nuclei     i o 
let virus_opt     i o = find_opt Area.Get.viruses    i o

let cytoplasm i o = find Area.Get.cytoplasms i o
let nucleus   i o = find Area.Get.nuclei     i o 
let virus     i o = find Area.Get.viruses    i o

let add_cytoplasm i x o = add Area.Map.cytoplasms i x o
let add_nucleus   i x o = add Area.Map.nuclei     i x o 
let add_virus     i x o = add Area.Map.viruses    i x o

let remove_cytoplasm i o = remove Area.Map.cytoplasms i o
let remove_nucleus   i o = remove Area.Map.nuclei     i o 
let remove_virus     i o = remove Area.Map.viruses    i o

let viruses predicate o =
  let viruses x =
    let predicate _ = predicate in
     x |> Area.Get.viruses
       |> HexMap.filter predicate
       |> HexMap.bindings in
  List.append
    (o |> Get.resolved
       |> viruses)
    (o |> Get.problems
       |> viruses)
                         
let replace map_source map_target i o =
  let o = match cytoplasm_opt i o with
          | Some x -> o |> map_source (Area.Map.cytoplasms (HexMap.remove i))
                        |> map_target (Area.Map.cytoplasms (HexMap.add  i x))
          | None   -> o in
  let o = match nucleus_opt i o with
          | Some x -> o |> map_source (Area.Map.nuclei (HexMap.remove i))
                        |> map_target (Area.Map.nuclei (HexMap.add  i x))
          | None   -> o in
  let o = match virus_opt i o with
          | Some x -> o |> map_source (Area.Map.viruses (HexMap.remove i))
                        |> map_target (Area.Map.viruses (HexMap.add  i x))
          | None   -> o in
      o
 
let resolve    i o = replace Map.problems Map.resolved i o
let problemize i o = replace Map.resolved Map.problems i o
                 
let is_resolved o =
  o |> Get.problems
    |> Area.is_empty
