open Data.Shared
open SHARED

module Make (ITEM : MODULE.T) : sig
    type e = (module ITEM.T)
    type t = (module DOTS_OF_DICE_NODE.MAKE (ITEM).T)

    val item : dots_of_dice -> t -> e
  end
