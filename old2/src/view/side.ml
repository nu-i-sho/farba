include Shared.Side

let sector_of =
  function | RightUp   -> 0
           | Up        -> 1
           | LeftUp    -> 2
           | LeftDown  -> 3
           | Down      -> 4
           | RightDown -> 5
