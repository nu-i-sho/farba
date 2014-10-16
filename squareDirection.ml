include Direction.Make (struct 
  type t = | Up
           | Down 
           | Left
           | Right

  let all_from_default_ordered_to_right = 
    [Up; Right; Down; Left]
end)
