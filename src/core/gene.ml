module OfFlesh = struct

  type t = | Cytoplazm of Pigment.t
           | Nacleus of Pigment.t * HexSide.t
           | Celluar of Pigment.t * HexSide.t
           | Cancer
end

module OfSpirit = struct
  type t = Dots.t
end

module OfProgramm = struct
  
  module ForAct = struct

    module ForReplicate = struct
      type t = | Direct
               | Inverse
    end

    type t = | Turn of HandSide.t
             | Replicate of ForReplicate.t 
  end

  type t = | Act of ForAct.t
           | Call of Dots.t
           | Declare of Dots.t
end

type t = | Flesh of OfFlesh.t
         | Spirit of OfSpirit.t
         | Code of OfProgramm.t
