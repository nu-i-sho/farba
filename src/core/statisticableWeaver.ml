open Data.Tissue
                      
type tissue = Weaver.tissue
type t = { base : Weaver.t;
           acts : Data.Statistics.Acts.t
         }

let extend weaver =
  { base = weaver;
    acts = Data.Statistics.Acts.(
             {      dummy_moves = 0;
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
           WeaverStage.( Data.Statistics.Acts.(
             match Weaver.stage base with
             | Created
               ->   a
             | Turned
               -> { a with turns = succ a.turns }
             | Moved (Success | ToClot | Out) 
               -> { a with moves = succ a.moves }
             | Moved Dummy
               -> { a with dummy_moves = succ a.dummy_moves }
             | Passed Success
               -> { a with passes = succ a.passes }
             | Passed Dummy
               -> { a with dummy_passes = succ a.dummy_passes }
             | Replicated (Success | ToClot | Out)
               -> { a with replicates = succ a.replicates }
             | Replicated Dummy
               -> { a with dummy_replicates =
                             succ a.dummy_replicates
                  }
           ))
  }

let replicate relation = count (Weaver.replicate relation)
let turn hand = count (Weaver.turn hand)
let pass = count Weaver.pass
let move = count Weaver.move
  
let statistics o =
  let acts =
    Data.Statistics.Acts.(
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
  Data.Statistics.Weaver.(
    { tissue;
      acts
    })
