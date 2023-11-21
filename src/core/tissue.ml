module HexMap = Map.Make(HexCoord)
module HexSet = Set.Make(HexCoord)

module AliveLayer = Layer.Make(struct
  type cytoplasm_t = Cytoplasm.Alive.t
  type nucleus_t = Nucleus.Alive.t
  end)

module DeadLayer = Layer.Make(struct
  type cytoplasm_t = Cytoplasm.Dead.t
  type nucleus_t = Nucleus.Dead.t
  end)

type cytoplasm_t = Cytoplasm.t
type nucleus_t = Nucleus.t
type virus_t = Virus.t

type t =
  {    viruses : virus_t HexMap.t;
         alive : AliveLayer.t;
          dead : DeadLayer.t;
    unresolved : HexSet.t
  }

module type LAYER_ADAPTER_T = sig
  type layer_t

  val get : t -> layer_t
  val map : (layer_t -> layer_t) -> t -> t
  end

module Adapt =
  functor (Layer : LAYER.T) ->
  functor (Adapter : LAYER_ADAPTER_T with type layer_t := Layer.t) ->
   struct
     type cytoplasm_t = Layer.cytoplasm_t
     type nucleus_t = Layer.nucleus_t
     type nonrec t = t
    
      let cytoplasm_opt    i   o = o |> Adapter.get |> Layer.cytoplasm_opt i
      let nucleus_opt      i   o = o |> Adapter.get |> Layer.nucleus_opt i    
      let cytoplasm        i   o = o |> Adapter.get |> Layer.cytoplasm i
      let nucleus          i   o = o |> Adapter.get |> Layer.nucleus i
                                 
      let add_cytoplasm    i x o = o |> Adapter.map (Layer.add_cytoplasm i x)
      let add_nucleus      i x o = o |> Adapter.map (Layer.add_nucleus i x)
      let remove_cytoplasm i   o = o |> Adapter.map (Layer.remove_cytoplasm i)
      let remove_nucleus   i   o = o |> Adapter.map (Layer.remove_nucleus i)
      end

module Alive = Adapt(AliveLayer)
  (struct
      let get o = o.alive
      let map f o =
        { o with
          alive = f o.alive
        } end)

module Dead = Adapt(DeadLayer)
  (struct
      let get o = o.dead
      let map f o =
        { o with
          dead = f o.dead
        } end)

let cytoplasm_opt i o =
  match       o |> Alive.cytoplasm_opt i with
  | None   -> o |> Dead.cytoplasm_opt i
                |> Option.map Cytoplasm.of_dead
  | x      -> x |> Option.map Cytoplasm.of_alive

let nucleus_opt i o =
  match       o |> Alive.nucleus_opt i with
  | None   -> o |> Dead.nucleus_opt i
                |> Option.map Nucleus.of_dead
  | x      -> x |> Option.map Nucleus.of_alive

let cytoplasm i o =
  match       o |> Alive.cytoplasm_opt i with
  | None   -> o |> Dead.cytoplasm i
                |> Cytoplasm.of_dead
  | Some x -> x |> Cytoplasm.of_alive

let nucleus i o =
  match       o |> Alive.nucleus_opt i with
  | None   -> o |> Dead.nucleus i
                |> Nucleus.of_dead
  | Some x -> x |> Nucleus.of_alive
  
let add_cytoplasm i x o =
  match x with
  | (`FinalB as x)
  | (`FinalG as x)
  | (`Trans  as x) -> o |> Alive.add_cytoplasm i x
  | (`Closed as x) -> o |> Dead.add_cytoplasm  i x

let add_nucleus i x o = 
  match x with
  | ((`HealthyB _) as x)
  | ((`HealthyG _) as x)
  | ((`Bastard  _) as x) -> o |> Alive.add_nucleus i x
  | ((`Clot     _) as x) -> o |> Dead.add_nucleus  i x

let remove_cytoplasm i o =
  o |> Alive.remove_cytoplasm i
    |> Dead.remove_cytoplasm i

let remove_nucleus i o =
  o |> Alive.remove_nucleus i
    |> Dead.remove_nucleus i

let virus_opt i o = o.viruses |> HexMap.find_opt i
let virus     i o = o.viruses |> HexMap.find i

let add_virus  i x o = { o with viruses = o.viruses |> HexMap.add i x  }
let remove_virus i o = { o with viruses = o.viruses |> HexMap.remove i }  

let viruses predicate o = 
  let predicate _ x = predicate x in
  o.viruses |> HexMap.filter predicate 
            |> HexMap.bindings

let resolve  i o = { o with unresolved = o.unresolved |> HexSet.remove i }
let dissolve i o = { o with unresolved = o.unresolved |> HexSet.add    i }          

let is_resolved o =
  HexSet.is_empty o.unresolved
