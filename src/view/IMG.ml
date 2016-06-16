module COMMAND = struct
    module type T = sig
	val get : Command.t -> Graphics.image
      end
  end

module DOTS_OF_DICE = struct
    module type T = sig
	val get : DotsOfDice.t -> Graphics.image
      end
  end

module type T = sig
    module Command : sig
	module Default          : COMMAND.T
	module Make (Prototypes : IMG_PROTOTYPE.COMMAND.T)
                                : COMMAND.T
      end 

    module Breadcrumbs : sig
	module Default          : DOTS_OF_DICE.T
	module Make (Prototypes : IMG_PROTOTYPE.DOTS_OF_DICE.T)
                                : DOTS_OF_DICE.T
      end
  end
