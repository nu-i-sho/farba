type t = | Nope
         | Pass
         | Move
         | Turn of Hand.t
         | Replicate of Relation.t
         | Call of DotsOfDice.t
         | Declare of DotsOfDice.t
         | End

let kind_of =
  function | Nope
           | Move
           | Pass
           | Turn _
           | Replicate _ -> CommandKind.Act
           | Call _      -> CommandKind.Call
           | Declare _   -> CommandKind.Declare
           | End         -> CommandKind.End
