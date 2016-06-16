type t = IMG.t

module Command : sig
    module Default          : IMG.COMMAND.T
    module Make (Prototypes : IMG_PROTOTYPE.COMMAND.T)
                            : IMG.COMMAND.T
  end 

module Breadcrumbs : sig
    module Default          : IMG.DOTS_OF_DICE.T
    module Make (Prototypes : IMG_PROTOTYPE.DOTS_OF_DICE.T)
                            : IMG.DOTS_OF_DICE.T
  end
