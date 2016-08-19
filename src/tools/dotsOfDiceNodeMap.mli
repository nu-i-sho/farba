module Make (ITEM : CONTRACTS.MODULE.T) : sig
    type e = (module ITEM.T)
    type t = (module CONTRACTS.DOTS_OF_DICE_NODE.MAKE (ITEM).T)

    val get : Data.DotsOfDice.t -> t -> e
  end
