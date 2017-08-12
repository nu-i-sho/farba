type t = int
       
open Data
   
let get =
  let open Command in
  function | Nope                       -> 0
           | Move                       -> 1
           | Pass                       -> 2
           | Turn Hand.Left             -> 3
           | Turn Hand.Right            -> 4
           | Replicate Relation.Direct  -> 5
           | Replicate Relation.Inverse -> 6
           | End                        -> 7
           | Declare x                  -> 8 + (DotsOfDice.index x)
           | Call x                     -> 8 +  DotsOfDice.count
                                             + (DotsOfDice.index x)
