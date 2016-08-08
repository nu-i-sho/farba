type t = Data.WeaverActsStatistics.t
open Data.WeaverActsStatistics

let zero = {      dummy_moves = 0;
                 dummy_passes = 0;
             dummy_replicates = 0;
                        turns = 0;
                        moves = 0;
                       passes = 0;
                   replicates = 0;
                    effective = 0;
                      dummies = 0;
                      summary = 0
           }
  
let increment act o =
  let open WeaverAct in
  match act with
  | Turn           -> { o with turns = o.turns + 1 }
  | Move           -> { o with moves = o.moves + 1 }
  | Pass           -> { o with passes = o.passes + 1 }
  | Replicate      -> { o with replicates = o.replicates + 1 }
  | DummyMove      -> { o with dummy_moves = o.dummy_moves + 1 }
  | DummyPass      -> { o with dummy_passes = o.dummy_passes + 1 }
  | DummyReplicate ->
     { o with dummy_replicates = o.dummy_replicates + 1 }

let calculate o =
  let effective, dummies =
    (o.turns + o.moves + o.passes + o.replicates),
    (o.dummy_moves + o.dummy_passes + o.dummy_replicates) in
  let summary = effective + dummies in
  { o with effective;
           dummies;
           summary
  }
