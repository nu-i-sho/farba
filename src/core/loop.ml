open Utils

module Die = struct
    type t = | Work of Dots.t * Dots.t
             | Wait of Dots.t

    let make dots = Wait dots
    let iter = function | Work (i, n) when n = i
                                      -> Wait n
                        | Wait     n  -> Work ((Dots.pred n), n) 
                        | Work (i, n) -> Work ((Dots.pred i), n)
                                       
    let reset (Work (x, _) | Wait x) = Wait x
  end

module Dice = struct
    type t = Die.t IntMap.t

    let empty = IntMap.empty
    let make  = IntMap.map Die.make 

    let die      = IntMap.find
    let die_opt  = IntMap.find_opt
    let is_empty = IntMap.is_empty
                
    let set_die i n = IntMap.set i (Die.Wait n)
    let remove_die  = IntMap.remove
      
    let iter_die i o =
      IntMap.set i (o |> die i
                      |> Die.iter) o 
      
    let reset_die i o =
      IntMap.set i (o |> die i
                      |> Die.reset) o
  end      
