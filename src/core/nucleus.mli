module Alive : sig
  type t =
    [ `HealthyB of Side.t
    | `HealthyG of Side.t
    | `Bastard  of Side.t
    ]

  type alive_t := t
    
  module Extraction : sig 
    type +'a t = private
      | Extracted of ([< alive_t ] as 'a)
      | Retracted of ([< alive_t ] as 'a)
    end

  module Injection : sig
    type +'a t = private
      | Injected  of ([< alive_t ] as 'a)
      | Rejected  of ([< alive_t ] as 'a)
    end

  module Replication : sig
    type +'a t = private
      | ReplicatedOut of ([< alive_t ] as 'a)
      | ReplicatedIn  of ([< alive_t ] as 'a) 
    end

  val gaze      : [< t ] -> Side.t
  val look_back : [< t ] -> t
  val turn      : Hand.t -> [< t ] -> t
  val extract   : [< Cytoplasm.Alive.t ] -> [< t ] -> t Extraction.t
  val inject    : [< Cytoplasm.t ] -> [< t ] -> t Injection.t
  val replicate : Gene.t -> [< Cytoplasm.Alive.t ] -> [< t ] -> t Replication.t
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

include DEADLY.T
  with type t := t
   and module Alive := Alive 
   and module Dead  := Dead

module Merge : sig
  type t = private
    | NucleiDissolved
    | CytoplasmClosed of Cytoplasm.Dead.t
    | NucleiClotted   of Dead.t
    | NucleiMerged    of [ `HealthyB of Side.t
                         | `HealthyG of Side.t
                         ]
  end

val merge : [< Alive.t] -> [< t] -> Merge.t
