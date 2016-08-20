type t = Data.Command.t
       
open Data
open Command
module Dots = DotsOfDice

let kind_of =
  function | Nope
           | Move
           | Pass
           | Turn _
           | Replicate _ -> CommandKind.Act
           | Call _      -> CommandKind.Call
           | Declare _   -> CommandKind.Declare
           | End         -> CommandKind.End
            
let index_of =
  function | Nope                       -> 0
           | Move                       -> 1
           | Pass                       -> 2
           | Turn Hand.Left             -> 3
           | Turn Hand.Right            -> 4
           | Replicate Relation.Direct  -> 5
           | Replicate Relation.Inverse -> 6
           | End                        -> 7
           | Declare x                  -> 8 + (Dots.index_of x)
           | Call x                     -> 8 +  Dots.count
                                             + (Dots.index_of x)
let compare x y =
  compare (index_of x)
          (index_of y)
