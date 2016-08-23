type t = | TissueCloted
         | OutOfTissue
         | OutOfSolution
         | Success
         | Dummy

val of_pass : PassStatus.t -> t
val of_move : MoveStatus.t -> t
