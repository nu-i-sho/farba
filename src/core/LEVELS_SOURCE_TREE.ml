module LEAF      = LEVEL_SOURCE
module BRANCHLET = DOTS_OF_DICE_NODE.MAKE (LEAF)
module BRANCH    = DOTS_OF_DICE_NODE.MAKE (BRANCHLET)
module ROOT      = DOTS_OF_DICE_NODE.MAKE (BRANCH)