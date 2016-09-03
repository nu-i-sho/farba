open Data

type tissue_t = Weaver.tissue_t
type t = { base : Weaver.t;
           acts : ActsStatistics.t
         }

let extend weaver =
  { base = weaver;
    acts = ActsStatistics.({      dummy_moves = 0;
                                 dummy_passes = 0;
                             dummy_replicates = 0;
                                        turns = 0;
                                        moves = 0;
                                       passes = 0;
                                   replicates = 0;
                                    effective = 0;
                                      dummies = 0;
                                      summary = 0
                           })
  }

let tissue o = o.base |> Weaver.tissue
let stage  o = o.base |> Weaver.stage

let count act o =
  let base = act o.base in
  { base;
    acts = let a = o.acts in
           WeaverStage.( ActsStatistics.(
             match Weaver.stage base with
             | Created
               -> a
             | Turned
               -> { a with turns = a.turns + 1 }
             | Moved (Success|ToClot|Out) 
               -> { a with moves = a.moves + 1 }
             | Moved Dummy
               -> { a with dummy_moves = a.dummy_moves + 1 }
             | Passed Success
               -> { a with passes = a.passes + 1 }
             | Passed Dummy
               -> { a with dummy_passes = a.dummy_passes + 1 }
             | Replicated (Success|ToClot|Out)
               -> { a with replicates = a.replicates + 1 }
             | Replicated Dummy
               -> { a with dummy_replicates = a.dummy_replicates + 1
                  }
           ))
  }

let replicate relation = count (Weaver.replicate relation)
let turn hand = count (Weaver.turn hand)
let pass = count Weaver.pass
let move = count Weaver.move
  
let statistics o =
  let acts =
    ActsStatistics.(
      let effective = o.acts.turns
                    + o.acts.moves
                    + o.acts.passes
                    + o.acts.replicates
      and dummies   = o.acts.dummy_moves
                    + o.acts.dummy_passes
                    + o.acts.dummy_replicates in
  
      let summary = effective + dummies in
      { o.acts with effective;
                    dummies;
                    summary
      })
  and tissue = TissueCounter.calculate_for (tissue o) in
  WeaverStatistics.(
    { tissue;
      acts
    })
