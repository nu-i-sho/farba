type t = Data.Command.t
       
open Data
open Command
module Dots = DotsOfDice
            
let index_of =
  function | Act     x -> ActionExt.index_of x
           | Nope      -> ActionExt.count
           | End       -> ActionExt.count + 1
           | Declare x -> ActionExt.count + 2 + (Dots.index_of x)
           | Call    x -> ActionExt.count + 2 +  Dots.count
                                              + (Dots.index_of x)  
let compare x y =
  compare (index_of x)
          (index_of y)
