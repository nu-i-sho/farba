let rec make value length = 
  if length <> 0 then 
    value :: (make value (length - 1)) else
    []

let make_1 = make 1
let make_6 = make 6
