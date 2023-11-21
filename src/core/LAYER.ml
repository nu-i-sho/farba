module SEED = struct
  module type T = sig
    type cytoplasm_t
    type nucleus_t
    end
  end

module type T = sig
  include SEED.T
  type t

  val cytoplasm_opt    : HexCoord.t -> t -> cytoplasm_t option 
  val nucleus_opt      : HexCoord.t -> t -> nucleus_t option
  val cytoplasm        : HexCoord.t -> t -> cytoplasm_t
  val nucleus          : HexCoord.t -> t -> nucleus_t 

  val add_cytoplasm    : HexCoord.t -> cytoplasm_t -> t -> t
  val add_nucleus      : HexCoord.t -> nucleus_t -> t -> t
  val remove_cytoplasm : HexCoord.t -> t -> t
  val remove_nucleus   : HexCoord.t -> t -> t
  end

module MAKE = struct
  module type T = functor(Seed : SEED.T) ->  
    T with type cytoplasm_t = Seed.cytoplasm_t
       and type nucleus_t = Seed.nucleus_t
  end
