module Commands = struct
    type t = {  replications : int;
                      passes : int;
                       turns : int;
                       moves : int;
                       calls : int;
                declarations : int;
                        ends : int;
                       nopes : int;
                        acts : int;
                       marks : int;
                      senced : int;
                         all : int
             }
  end

module Acts = struct
    type t = {      dummy_moves : int;
                   dummy_passes : int;
               dummy_replicates : int;
                          turns : int;
                          moves : int;
                         passes : int;
                     replicates : int;
                      effective : int;
                        dummies : int;
                        summary : int
         }
  end
                
module Tissue = struct
    type t = { healthy_cells_capacity : int;
                        healthy_cells : int;
                         cancer_cells : int;
                            is_cloted : bool;
                             is_outed : bool
             }
  end

module Weaver = struct
    type t = { tissue : Tissue.t;
                 acts : Acts.t
             }
  end

module Summary = struct
    type t = { solution : Commands.t;
                 tissue : Tissue.t; 
                   acts : Acts.t
             }
  end
