module OfFlesh = struct
    module Kind = struct
	type t = | Cytoplazm of Pigment.t
                 | Nucleus of Pigment.t * HexagonSide.t
                 | Celluar of Pigment.t * HexagonSide.t
                 | Cancer
                 | Clot 
      end

    module Command = struct

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
  end

module OfSpirit = struct
    
    module Kind = struct
	type t = | ReinjectingVirus of RunMode.t
	         | MultiplyingVirus of RunMode.t
		 | ImmovableVirus
      end

    module Energy = struct
	type t = { value : DotsOfDice.t;
		   index : int
		 }
      end
  end

type t = | FleshKind of OfFlesh.Kind.t
         | FleshCommand of OfFlesh.Command.t
         | SpiritKind of OfSpirit.Kind.t
	 | SpiritEnergy of OfSpirit.Energy.t
