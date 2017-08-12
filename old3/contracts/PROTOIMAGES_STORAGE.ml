module type T = sig
    module X54 : sig
        module DotsOfDice : sig
            include DOTS_OF_DICE_NODE.MAKE (PROTOIMAGE).T
          end
             
        module Act : sig
            module Nope : PROTOIMAGE.T
            module Move : PROTOIMAGE.T
            module Pass : PROTOIMAGE.T
            module TurnLeft : PROTOIMAGE.T
            module TurnRight : PROTOIMAGE.T
            module ReplicateDirect : PROTOIMAGE.T
            module ReplicateInverse : PROTOIMAGE.T
          end

        module Border : PROTOIMAGE.T
        module End : PROTOIMAGE.T
             
      end

    module X20 : sig
        module DotsOfDice : sig
            include DOTS_OF_DICE_NODE.MAKE (PROTOIMAGE).T
          end
      end
  end
