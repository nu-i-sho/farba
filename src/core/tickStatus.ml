type t = | TissueCloted
         | OutOfTissue
         | OutOfSolution
         | Success
         | Dummy

let of_pass =
  function | PassStatus.Success -> Success
           | PassStatus.Dummy   -> Dummy
                    
let of_move =
  function | MoveStatus.Success -> Success
           | MoveStatus.Dummy   -> Dummy
           | MoveStatus.Clot    -> TissueCloted
           | MoveStatus.Outed   -> OutOfTissue
