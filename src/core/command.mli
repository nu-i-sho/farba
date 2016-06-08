type t = | Turn of HandSide.t
	 | Replicate of Relationship.t
	 | Call of DotsOfDice.t 
	 | Declare of DotsOfDice.t
         | End

val of_char : char -> t
val to_char : t -> char

