include Direction.Make(struct
  type t = Hand.t
  let all_from_default_ordered_to_right = 
    Hand.([Right; Left])
end)
