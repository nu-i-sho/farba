module Dead = struct
  type t =
    [ `Clot of Consistence.t
    ]
  end

module Alive = struct
  type t =
    [ `HealthyB of Side.t
    | `HealthyG of Side.t
    | `Bastard  of Side.t
    ]

  let gaze = function
    | `HealthyB x
    | `HealthyG x
    | `Bastard  x -> x
  
  let map f = function
    | `HealthyB gaze -> `HealthyB (f gaze)
    | `HealthyG gaze -> `HealthyG (f gaze)
    | `Bastard  gaze -> `Bastard  (f gaze)

  let look_back o = o |> map  Side.opposite
  let turn hand o = o |> map (Side.turn hand) 

  module Extraction = struct
    type nonrec +'a t =
      | Extracted of ([< t ] as 'a)
      | Retracted of ([< t ] as 'a)
    end

  let extract from_cytoplasm o =
    match from_cytoplasm with
    | `FinalB  
    | `FinalG -> Extraction.Retracted (look_back o)
    | `Trans  -> Extraction.Extracted (o :> t)
  
  module Injection = struct
    type nonrec +'a t =
      | Injected of ([< t ] as 'a)
      | Rejected of ([< t ] as 'a)
    end
  
  let inject to_cytoplasm o =
    match o, to_cytoplasm with
    | (`HealthyG _), `FinalB
    | (`HealthyB _), `FinalG  
    |  _           , `Trans  -> Injection.Injected (o :> t)
    | (`HealthyB x), `FinalB
    | (`HealthyG x), `FinalG
    | (`Bastard  x), `FinalB 
    | (`Bastard  x), `FinalG -> Injection.Injected (`Bastard x)
    |   _          , `Closed -> Injection.Rejected (look_back o)

  module Replication = struct
    type nonrec +'a t =
      | ReplicatedOut of ([< t ] as 'a)
      | ReplicatedIn  of ([< t ] as 'a)
    end
  
  let replicate gene from_cytoplasm o =
    let child =
      ( match gene, o with
        | Gene.Recessive, (`HealthyB x) -> `HealthyG x
        | Gene.Recessive, (`HealthyG x) -> `HealthyB x
        | Gene.Recessive, (`Bastard  _)
        | Gene.Dominant ,  _            -> (o :> t)
      ) |> look_back in
    match from_cytoplasm with
    | `FinalB | `FinalG -> Replication.ReplicatedOut child
    | `Trans            -> Replication.ReplicatedIn  child
  end

type t =
  [ Alive.t
  | Dead.t
  ]

let of_alive x = (x : Alive.t :> t)
let of_dead  x = (x : Dead.t  :> t)

let to_alive_opt = function
  | ((`HealthyB _) as x)
  | ((`HealthyG _) as x)
  | ((`Bastard  _) as x) -> Some x
  |   `Clot     _        -> None

let to_dead_opt = function
  |   `HealthyB _
  |   `HealthyG _
  |   `Bastard  _    -> None
  | ((`Clot _) as x) -> Some x

let is_alive x = Option.is_some (to_alive_opt x) 
let is_dead  x = Option.is_some (to_dead_opt x)
    
module Merge = struct
  type t =
    | NucleiDissolved
    | CytoplasmClosed of Cytoplasm.Dead.t
    | NucleiClotted   of Dead.t
    | NucleiMerged    of [ `HealthyB of Side.t
                         | `HealthyG of Side.t
                         ]
  end

let merge o1 o2 =
  let module Cons = Consistence in
  let open Merge in
  match o1, o2 with
  | (`HealthyB _), (`Clot Cons.Dot)
  | (`HealthyG _), (`Clot Cons.Dot) -> CytoplasmClosed `Closed
  | (`Bastard  _), (`Bastard  _)    -> NucleiDissolved
  | (`HealthyB _), (`Bastard  b)       
  | (`Bastard  b), (`HealthyB _)    -> NucleiMerged (`HealthyB b)
  | (`HealthyG _), (`Bastard  b)
  | (`Bastard  b), (`HealthyG _)    -> NucleiMerged (`HealthyG b)
  | (`HealthyB _), (`Clot     c)
  | (`HealthyG _), (`Clot     c)    -> NucleiClotted (`Clot (c |> Cons.succ))
  | (`Bastard  _), (`Clot     c)    -> NucleiClotted (`Clot  c)
  | (`HealthyB _ | `HealthyG  _),
    (`HealthyG _ | `HealthyB  _)    -> NucleiClotted (`Clot Cons.origin)
