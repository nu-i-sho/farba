type t = Index.t

let zero = (0, 0)
let move side (x, y) =
  Side.( match side with
         | Up        -> (x    , y - 1)
         | LeftUp    -> (x - 1, y - 1)
         | RightUp   -> (x + 1, y - 1)
         | Down      -> (x    , y + 1)
         | LeftDown  -> (x - 1, y    )
         | RightDown -> (x + 1, y    ))
