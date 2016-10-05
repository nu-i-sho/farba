open Data.Shared
open SHARED

module Make (ITEM : MODULE.T) = struct
    module type ITEM = ITEM.T
    module type NODE = DOTS_OF_DICE_NODE.MAKE (ITEM).T

    type e = (module ITEM)
    type t = (module NODE)
    
    let item dots (module Node : NODE) =
      match dots with
      | OOOOOO -> (module Node.OOOOOO : ITEM)
      | OOOOO -> (module Node.OOOOO : ITEM)
      | OOOO -> (module Node.OOOO : ITEM)
      | OOO -> (module Node.OOO : ITEM)
      | OO -> (module Node.OO : ITEM)
      | O -> (module Node.O : ITEM)
  end
