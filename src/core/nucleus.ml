module Alive = struct
  type t =
    [ `HealthyB of Side.t
    | `HealthyG of Side.t
    | `Bastard  of Side.t
    ]

  let map f = function
    | `HealthyB gaze -> `HealthyB (f gaze)
    | `HealthyG gaze -> `HealthyG (f gaze)
    | `Bastard  gaze -> `Bastard  (f gaze)  
  end

module Dead = struct
  type t = [ `Clot of Consistence.t ]
  end

type t =
  [ Alive.t
  | Dead.t
  ]

let of_alive x = (x : Alive.t :> t)
let of_dead  x = (x : Dead.t  :> t)

let look_back = Alive.map  Side.opposite
let turn hand = Alive.map (Side.turn hand) 

module ExtractionResult = struct
  type t =
    | Extracted of Alive.t
    | Retracted of Alive.t
  end

let extract from_cytoplasm o =
  match from_cytoplasm with
  | `FinalB  
  | `FinalG -> ExtractionResult.Retracted (look_back o)
  | `Trans  -> ExtractionResult.Extracted o 

module InjectionResult = struct
  type t =
    | Injected of Alive.t
    | Rejected of Alive.t
  end

let inject to_cytoplasm o =
  match o, to_cytoplasm with
  | (`HealthyG _), `FinalB
  | (`HealthyB _), `FinalG  
  |  _           , `Trans  -> InjectionResult.Injected o
  | (`HealthyB x), `FinalB
  | (`HealthyG x), `FinalG
  | (`Bastard  x), `FinalB 
  | (`Bastard  x), `FinalG -> InjectionResult.Injected (`Bastard x)
  |   _          , `Closed -> InjectionResult.Rejected (look_back o)

module ReplicationResult = struct
  type t =
    | ReplicatedOut of Alive.t
    | ReplicatedIn  of Alive.t 
  end

let replicate gene from_cytoplasm o =
  let child =
    ( match gene, o with
      | Gene.Recessive, (`HealthyB x) -> `HealthyG x
      | Gene.Recessive, (`HealthyG x) -> `HealthyB x
      | Gene.Recessive, (`Bastard  _)
      | Gene.Dominant ,  _            -> o
    ) |> look_back in
  match from_cytoplasm with
  | `FinalB | `FinalG -> ReplicationResult.ReplicatedOut child
  | `Trans            -> ReplicationResult.ReplicatedIn  child
    
module MergeResult = struct
  type t =
    | NucleiDissolved
    | CytoplasmClosed of Cytoplasm.Dead.t
    | NucleiMerged    of [ `HealthyB of Side.t
                         | `HealthyG of Side.t
                         | Dead.t
                         ]
  end

let merge o1 o2 =
  let module Cons = Consistence in
  let open MergeResult in
  match o1, o2 with
  | (`HealthyB _), (`Clot Cons.Dot)
  | (`HealthyG _), (`Clot Cons.Dot) -> CytoplasmClosed `Closed
  | (`Bastard  _), (`Bastard  _)    -> NucleiDissolved
  | (`HealthyB _), (`Bastard  b)       
  | (`Bastard  b), (`HealthyB _)    -> NucleiMerged (`HealthyB b)
  | (`HealthyG _), (`Bastard  b)
  | (`Bastard  b), (`HealthyG _)    -> NucleiMerged (`HealthyG b)
  | (`HealthyB _), (`Clot     c)
  | (`HealthyG _), (`Clot     c)    -> NucleiMerged (`Clot (c |> Cons.succ))
  | (`Bastard  _), (`Clot     c)    -> NucleiMerged (`Clot  c)
  | (`HealthyB _ | `HealthyG  _),
    (`HealthyG _ | `HealthyB  _)    -> NucleiMerged (`Clot Cons.origin)
