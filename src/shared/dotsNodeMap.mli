open Data.Shared
open SHARED

module Make (ITEM : MODULE.T) : sig
    type e = (module ITEM.T)
    type t = (module DOTS_NODE.MAKE (ITEM).T)

    val item : dots -> t -> e
  end
