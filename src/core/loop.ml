open Utils

module Die = struct
    type t = | Work of Dots.t * Dots.t
             | Wait of Dots.t
  end

module Dice = struct
    type t = Die.t IntMap.t

    let origin    = IntMap.empty
    let die       = IntMap.item
    let maybe_die = IntMap.maybe_item
    let set i n   = IntMap.set i (Die.Wait n)
    let remove    = IntMap.remove
      
    let iter i o =
      let pred = Dots.cycle_pred in
      let die =
        Die.( match die i o with
              | Work (i, n) when n = i
                            -> Wait n
              | Wait     n  -> Work ((pred n), n) 
              | Work (i, n) -> Work ((pred i), n)
        ) in
      IntMap.set i die o 
      
      
    let reset i o =
      let Die.(Work (x, _) | Wait x) = die i o in
      set i x o
  end      
