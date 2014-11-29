include Direction.Make(struct
  type t = | Up
           | Rightup
	   | Rightdown
	   | Down
	   | Leftdown
	   | Leftup

  let all_from_default_ordered_to_right = 
    [Up; Rightup; Rightdown; Down; Leftdown; Leftup]
end)
