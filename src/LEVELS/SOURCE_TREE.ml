module LEAF = struct
    module type T = sig
        val flora  : string list lazy_t
        val fauna  : string list lazy_t
        val active : string list lazy_t
      end
  end
            
module BRANCHLET = SHARED.DOTS_OF_DICE_NODE.MAKE (LEAF)
module BRANCH    = SHARED.DOTS_OF_DICE_NODE.MAKE (BRANCHLET)
module ROOT      = SHARED.DOTS_OF_DICE_NODE.MAKE (BRANCH)
