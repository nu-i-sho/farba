include Direction.Make(struct
  type t = | Up
           | Rightup
	   | Rightdown
	   | Down
	   | Leftdown
	   | Leftup

  let all_ordered_to_right = 
    [Down; Leftdown; Leftup; Up; Rightup; Rightdown]
end)
