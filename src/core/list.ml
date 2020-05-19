include List
      
let hd_opt = function
  | h :: _ -> Some h
  | []     -> None
