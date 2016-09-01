type t = | Created
         | TissueCloted
         | OutedOfTissue
         | OutedOfSolution
         | SuccessTicked
         | DummyTicked

let of_weaver_stage =
  Data.WeaverStage.(
    function | Turned
             | Passed Success
             | Moved Success
             | Replicated Success -> SuccessTicked
             | Passed Dummy
             | Moved Dummy
             | Replicated Dummy   -> DummyTicked
             | Moved Out
             | Replicated Out     -> OutedOfTissue
             | Moved ToClot
             | Replicated ToClot  -> TissueCloted
             | Created            -> Created
  )
