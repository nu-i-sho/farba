type t = Data.Command.t
       
let of_char =
  Data.( Hand.( Relation.( Action.(
    DotsOfDice.( Command.(
                                            
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

               | '0' -> Nope
               | 'X' -> End
                    
               | _   -> failwith Fail.invalid_symbol
  ))))))
