type alive_t :=
  [ `HealthyB of Side.t
  | `HealthyG of Side.t
  | `Bastard  of Side.t
  ]

type dead_t := 
  [ `Clot of Consistence.t
  ]

type t =
  [ alive_t
  | dead_t
  ]

include DEADLY.T
   with type t := t
    and type Alive.t = alive_t
    and type Dead.t = dead_t

module ExtractionResult : sig
  type t = private
    | Extracted of Alive.t
    | Retracted of Alive.t
  end

module InjectionResult : sig
  type t = private
    | Injected of Alive.t
    | Rejected of Alive.t
  end

module ReplicationResult : sig
  type t = private
    | ReplicatedOut of Alive.t
    | ReplicatedIn  of Alive.t 
  end

module MergeResult : sig
  type t = private
    | NucleiDissolved
    | CytoplasmClosed of Cytoplasm.Dead.t
    | NucleiMerged    of [ `HealthyB of Side.t
                         | `HealthyG of Side.t
                         | Dead.t
                         ]
  end
  
val look_back : Alive.t -> Alive.t
val turn      : Hand.t -> Alive.t -> Alive.t
val extract   : Cytoplasm.Alive.t -> Alive.t -> ExtractionResult.t
val inject    : Cytoplasm.t -> Alive.t -> InjectionResult.t
val replicate : Gene.t -> Cytoplasm.Alive.t -> Alive.t -> ReplicationResult.t
val merge     : Alive.t -> t -> MergeResult.t
