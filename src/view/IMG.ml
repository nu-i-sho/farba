type t = int array array

module COMMAND = struct
    module type T = sig
	val get : Command.t -> t
      end
  end

module DOTS_OF_DICE = struct
    module type T = sig
	val get : DotsOfDice.t -> t
      end
  end
