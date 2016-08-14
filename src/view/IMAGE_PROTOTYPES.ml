module DOTS_OF_DICE = struct
    module type T = sig
        module OOOOOO : IMAGE_PROTOTYPE.T
        module OOOOO : IMAGE_PROTOTYPE.T
        module OOOO : IMAGE_PROTOTYPE.T
        module OOO : IMAGE_PROTOTYPE.T
        module OO : IMAGE_PROTOTYPE.T
        module O : IMAGE_PROTOTYPE.T
      end
  end

module type T = sig
    module X54 : sig
        module DotsOfDice : sig
            include DOTS_OF_DICE.T
          end
             
        module Act : sig
            module Nope : IMAGE_PROTOTYPE.T
            module Move : IMAGE_PROTOTYPE.T
            module Pass : IMAGE_PROTOTYPE.T
            module TurnLeft : IMAGE_PROTOTYPE.T
            module TurnRight : IMAGE_PROTOTYPE.T
            module ReplicateDirect : IMAGE_PROTOTYPE.T
            module ReplicateInverse : IMAGE_PROTOTYPE.T
          end

        module Border : IMAGE_PROTOTYPE.T
        module End : IMAGE_PROTOTYPE.T
             
      end

    module X20 : sig
        module DotsOfDice : sig
            include DOTS_OF_DICE.T
          end
      end
  end
