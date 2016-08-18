type t = | Nope
         | Pass
         | Move
         | Turn of Hand.t
         | Replicate of Relation.t
         | Call of DotsOfDice.t
         | Declare of DotsOfDice.t
         | End
