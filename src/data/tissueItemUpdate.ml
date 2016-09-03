type dummy_action_t = | Replicate
                      | Pass
                      | Move

type t = | Inject of Pigment.t * Cell.t
         | Extract of Cell.t * Pigment.t
         | Turn of Cell.t * Cell.t
         | VirusOut of Cell.t * Cell.t
         | Infect of Cell.t * Cell.t
         | DoClot of Cell.t * Side.t
         | MoveOut of Nucleus.t
         | DummyAct of dummy_action_t
