type t = | Run
         | GoTo of DotsOfDice.t
         | Return
         | RunNext
         
let kind_of =
  function | GoTo _
           | Return
           | RunNext -> RuntimeModeKind.Find
           | Run     -> RuntimeModeKind.Run
