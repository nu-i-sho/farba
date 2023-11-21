module type T = sig
  type t

  module Alive :
    LAYER.T with type t = t
             and type cytoplasm_t = Cytoplasm.Alive.t
             and type nucleus_t = Nucleus.Alive.t

  module Dead :
    LAYER.T with type t = t
             and type cytoplasm_t = Cytoplasm.Dead.t
             and type nucleus_t = Nucleus.Dead.t

  include LAYER.T
     with type t := t
      and type cytoplasm_t = Cytoplasm.t
      and type nucleus_t = Nucleus.t

  type virus_t = Virus.t 
  
  val virus_opt    : HexCoord.t -> t -> virus_t option
  val virus        : HexCoord.t -> t -> virus_t
  val add_virus    : HexCoord.t -> virus_t -> t -> t
  val remove_virus : HexCoord.t -> t -> t  
  val viruses      : (virus_t -> bool) -> t -> (HexCoord.t * virus_t) list 
  end

module RESOLVABLE = struct
  module type T = sig
    include T

    val resolve      : HexCoord.t -> t -> t 
    val dissolve     : HexCoord.t -> t -> t
    val is_resolved  : t -> bool      
    end
  end

module TRANSACTIONAL = struct
  module type T = sig
    include T
    type original_t

    val open' : original_t -> t
    val close : t -> original_t
    end
  end
