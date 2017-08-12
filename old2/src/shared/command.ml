type t = | Move
         | Turn of Hand.t
	 | Replicate of Relationship.t
	 | Call of DotsOfDice.t 
	 | Declare of DotsOfDice.t
         | End
