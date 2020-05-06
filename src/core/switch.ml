type 'a t =
  | On  of 'a
  | Off of 'a

let turn_on  (On x | Off x) = On x
let turn_off (On x | Off x) = Off x
let turn = function
  | On  x -> Off x
  | Off x -> On  x
