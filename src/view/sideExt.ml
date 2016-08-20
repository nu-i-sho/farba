type t = Data.Side.t

open Data
open Side
       
let sector_of =
  function | RightUp   -> 0.0
           | Up        -> 1.0
           | LeftUp    -> 2.0
           | LeftDown  -> 3.0
           | Down      -> 4.0
           | RightDown -> 5.0
