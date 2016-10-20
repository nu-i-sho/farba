open Data.Shared
open Shared.Fail

type t = arg

let of_char : char -> t =
  function | '1' -> Act Pass
           | '2' -> Act Move
           | '3' -> Act (Turn Left) 
           | '4' -> Act (Turn Right)
           | '5' -> Act (Replicate Direct)
           | '6' -> Act (Replicate Inverse)
                      
           | 'a' -> Call O
           | 'b' -> Call OO
           | 'c' -> Call OOO
           | 'd' -> Call OOOO
           | 'e' -> Call OOOOO
           | 'f' -> Call OOOOOO
                      
           | 'A' -> Declare O
           | 'B' -> Declare OO
           | 'C' -> Declare OOO
           | 'D' -> Declare OOOO
           | 'E' -> Declare OOOOO
           | 'F' -> Declare OOOOOO
         
           | _   -> raise (Inlegal_case "Core.Arg.of_char")
