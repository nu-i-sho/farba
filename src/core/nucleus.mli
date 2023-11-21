module Alive : sig
  type t =
    [ `HealthyB of Side.t
    | `HealthyG of Side.t
    | `Bastard  of Side.t
    ]
  end

module Dead : sig
  type t =
    [ `Clot of Consistence.t
    ]
  end

type t =
  [ Alive.t
  | Dead.t
  ]

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

val of_alive  : Alive.t -> t
val of_dead   : Dead.t -> t
  
val look_back : Alive.t -> Alive.t
val turn      : Hand.t -> Alive.t -> Alive.t
val extract   : Cytoplasm.Alive.t -> Alive.t -> ExtractionResult.t
val inject    : Cytoplasm.t -> Alive.t -> InjectionResult.t
val replicate : Gene.t -> Cytoplasm.Alive.t -> Alive.t -> ReplicationResult.t
val merge     : Alive.t -> t -> MergeResult.t
