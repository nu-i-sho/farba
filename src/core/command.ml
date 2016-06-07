type t = | Turn of HandSide.t
	 | Replicate of Relationship.t
	 | Call of DotsOfDice.t 
	 | Declare of DotsOfDice.t
	 | Begin
         | End
