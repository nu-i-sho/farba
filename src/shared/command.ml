type t = | Turn of Hand.t
	 | Replicate of Relationship.t
	 | Call of DotsOfDice.t 
	 | Declare of DotsOfDice.t
         | End

open Hand
open Relationship
open DotsOfDice

let of_char = 
  function | '0' -> Turn Left 
           | '1' -> Turn Right
           | '2' -> Replicate Direct
           | '3' -> Replicate Inverse
           | '4' -> Call O
           | '5' -> Call OO
           | '6' -> Call OOO
           | '7' -> Call OOOO
           | '8' -> Call OOOOO
           | '9' -> Call OOOOOO
           | 'A' -> Declare OOOOOO
           | 'B' -> Declare OOOOO
           | 'C' -> Declare OOOO
           | 'D' -> Declare OOO
           | 'E' -> Declare OO
           | 'F' -> Declare O

let to_char = 
  function | Turn Left         -> '0'  
           | Turn Right        -> '1' 
           | Replicate Direct  -> '2'
           | Replicate Inverse -> '3'
           | Call O            -> '4'
           | Call OO           -> '5'
           | Call OOO          -> '6'
           | Call OOOO         -> '7'
           | Call OOOOO        -> '8'
           | Call OOOOOO       -> '9'
           | Declare OOOOOO    -> 'A'
           | Declare OOOOO     -> 'B'
           | Declare OOOO      -> 'C'
           | Declare OOO       -> 'D'
           | Declare OO        -> 'E'
           | Declare O         -> 'F'
