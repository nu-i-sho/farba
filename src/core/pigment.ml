type t = White | Blue | Gray
                      
let rev = function
  | White -> White
  | Blue  -> Gray
  | Gray  -> Blue
