type t = Data.Command.t

let of_char =
  let open Data.Hand in
  let open Data.Relation in
  let open Data.DotsOfDice in
  let open Data.Command in

  function | '1' -> Pass
           | '2' -> Move
           | '3' -> Turn Left 
           | '4' -> Turn Right
           | '5' -> Replicate Direct
           | '6' -> Replicate Inverse

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

           | '0' -> Nope
           | 'X' -> End
                  
           | _   -> failwith "invalid char"
