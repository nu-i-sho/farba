type t = | Created
         | TissueCloted
         | OutedOfTissue
         | OutedOfSolution
         | SuccessTicked
         | DummyTicked

val of_weaver_stage : Data.WeaverStage.t -> t
