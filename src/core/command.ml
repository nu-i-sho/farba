module ForAct = struct
    type t = | Turn of HandSide.t
	     | Replicate of Relationship.t
	     | Call of DotsOfDice.t 
  end

module ForMark = struct
    type t = | Declare of DotsOfDice.t
	     | Begin
	     | End
  end

type t = | Act of ForAct.t
         | Mark of ForMark.t

