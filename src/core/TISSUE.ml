module READ_ONLY = struct

  module COVER_SEED = struct
    module type T = sig
      type original_t
      type t
       val original : t -> original_t
       end
    end
  
  module SUB = struct
    module type T = sig
      type cytoplasm_t
      type nucleus_t
      type t
    
       val cytoplasm_opt : HexCoord.t -> t -> cytoplasm_t option 
       val nucleus_opt   : HexCoord.t -> t -> nucleus_t option
       val cytoplasm     : HexCoord.t -> t -> cytoplasm_t
       val nucleus       : HexCoord.t -> t -> nucleus_t 
       end
    end

  module type T = sig
    include SUB.T
       with type cytoplasm_t := Cytoplasm.t
        and type nucleus_t := Nucleus.t

    module Alive
      : SUB.T with type t := t
               and type cytoplasm_t := Cytoplasm.Alive.t
               and type nucleus_t := Nucleus.Alive.t
    module Dead
      : SUB.T with type t := t
               and type cytoplasm_t := Cytoplasm.Dead.t
               and type nucleus_t := Nucleus.Dead.t
                                       
    val viruses_coords : Virus.t -> t -> HexCoord.t list 
    val virus_opt      : HexCoord.t -> t -> Virus.t option
    val virus          : HexCoord.t -> t -> Virus.t
    val is_resolved    : t -> bool      
    end
  end
           
module type T = sig
  include READ_ONLY.T

  val add_cytoplasm    : HexCoord.t -> Cytoplasm.t -> t -> t
  val add_nucleus      : HexCoord.t -> Nucleus.t -> t -> t
  val add_virus        : HexCoord.t -> Virus.t -> t -> t
  val remove_cytoplasm : HexCoord.t -> t -> t
  val remove_nucleus   : HexCoord.t -> t -> t
  val remove_virus     : HexCoord.t -> t -> t
  val resolve          : HexCoord.t -> t -> t 
  val dissolve         : HexCoord.t -> t -> t
  end

module COVER_SEED = struct
  module type T = sig
    include READ_ONLY.COVER_SEED.T
    val map_original : (original_t -> original_t) -> t -> t
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
