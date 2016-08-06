module Make (ITEM : MODULE.T) = struct
    module type E = ITEM.T
    module type T = DOTS_OF_DICE_NODE.MAKE (ITEM).T

    type e = (module E)
    type t = (module T)
    
    let get dots (module O : T) =
      let open Data.DotsOfDice in
      match dots with
      | OOOOOO -> (module O.OOOOOO : E)
      | OOOOO -> (module O.OOOOO : E)
      | OOOO -> (module O.OOOO : E)
      | OOO -> (module O.OOO : E)
      | OO -> (module O.OO : E)
      | O -> (module O.O : E)
  end
