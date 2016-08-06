module Make (ITEM : MODULE.T) = struct
    module NODE = DOTS_OF_DICE_NODE.MAKE (ITEM)
    module type E = NODE.E
    module type T = NODE.T

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
