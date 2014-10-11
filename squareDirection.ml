include Direction.Make (struct 
  type t = | Up
           | Down 
           | Left
           | Right

  let all_ordered_to_right = 
    [Down; Left; Up; Right]
end)
