type t = int

let out_of_range x = (string_of_int x)
                   ^ " is out of range of Dots values"
let to_string =
  function | 1 -> "O"
	   | 2 -> "OO"
	   | 3 -> "OOO"
           | 4 -> "OOOO"
           | 5 -> "OOOOO"
	   | 6 -> "OOOOOO"
	   | x -> failwith (out_of_range x) 
  
let all_strings =
  [ "O"; "OO"; "OOO"; "OOOO"; "OOOOO"; "OOOOOO" ]
