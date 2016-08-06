module Make (ITEM : MODULE.T) : sig
    type e = (module ITEM.T)
    type t = (module DOTS_OF_DICE_NODE.MAKE (ITEM).T)
    
    val get : DotsOfDice.t -> t -> e
  end
