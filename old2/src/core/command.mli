include Shared.Command

let of_char = 
  let open Hand in
  let open Relationship in
  let open DotsOfDice in

  function | '0' -> Move
           | '1' -> Turn Left 
           | '2' -> Turn Right
           | '3' -> Replicate Direct
           | '4' -> Replicate Inverse
           | 'a' -> Call O
           | 'b' -> Call OO
           | 'c' -> Call OOO
           | 'd' -> Call OOOO
           | 'e' -> Call OOOOO
           | 'f' -> Call OOOOOO
           | 'A' -> Declare OOOOOO
           | 'B' -> Declare OOOOO
           | 'C' -> Declare OOOO
           | 'D' -> Declare OOO
           | 'E' -> Declare OO
           | 'F' -> Declare O
