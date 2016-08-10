open Data.Statistics.OfCommands
open Data.Command

let zero = { replications = 0;  
                   passes = 0;  
                    turns = 0;  
                    moves = 0;  
                    calls = 0;  
             declarations = 0;  
                     ends = 0;  
                    nopes = 0;  
                     acts = 0;  
                    marks = 0;  
                   senced = 0;  
                      all = 0  
           }
         
let calculate_for solution =
  let calc acc = 
    function | Pass        -> { acc with passes = acc.passes + 1 }
             | Move        -> { acc with moves = acc.moves   + 1 }
             | Turn _      -> { acc with turns = acc.turns   + 1 }
             | Replicate _ -> { acc with replications =
                                           acc.replications  + 1 }
             | Nope        -> { acc with nopes = acc.turns   + 1 } 
             | Call _      -> { acc with calls = acc.calls   + 1 }
             | Declare _   -> { acc with declarations =
                                           acc.declarations  + 1 }
             | End         -> { acc with ends = acc.ends     + 1 }
  in
  
  let acc = Solution.fold calc zero solution in
  let acts   = acc.passes
             + acc.moves
             + acc.turns
             + acc.replications
  and marks  = acc.declarations
             + acc.calls
             + acc.ends in  
  let senced = acc.acts
             + acc.marks in  
  let all    = acc.senced
             + acc.nopes in
  { acc with acts; marks; senced; all }
