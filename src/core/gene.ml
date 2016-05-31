module OfFlesh = struct
  type t = | Cytoplazm of Pigment.t
           | Nacleus of Pigment.t * HexSide.t
           | Celluar of Pigment.t * HexSide.t
           | Cancer
end

module OfSpirit = struct
  type t = DotsOfDice.t
end

module OfProgramm = struct

  module ForAct = struct
    type t = | Turn of HandSide.t
             | Replicate of Relationship.t
             | Call of DotsOfDice.t 
  end

  module ForMark = struct
    type t = | Declare of DotsOfDice.t
             | End
  end

  type t = | Act of ForAct.t
           | Mark of ForMark.t
end

type t = | Flesh of OfFlesh.t
         | Spirit of OfSpirit.t
         | Code of OfProgramm.t
