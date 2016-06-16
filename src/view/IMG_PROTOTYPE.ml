module type T = sig
    val matrix : string array Lazy.t
end

module DOTS_OF_DICE = struct
    module type T = sig
	module OOOOOO : T
	module OOOOO : T
	module OOOO : T
	module OOO : T
	module OO : T
	module O : T
      end
  end

module ACT = struct
    module type T = sig
	module TurnLeft : T
	module TurnRight : T
	module ReplicateDirect : T
	module ReplicateInverse : T
      end
  end

module COMMAND = struct
    module type T = sig
	module DotsOfDice : DOTS_OF_DICE.T
	module Act : ACT.T
	module End : T
      end
  end
