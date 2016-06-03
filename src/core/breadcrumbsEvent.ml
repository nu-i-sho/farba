type t = | New    (DotsOfDice.t * int)
         | Move   (DotsOfDice.t * int * int) 
         | Remove (DotsOfDice.t * int)
