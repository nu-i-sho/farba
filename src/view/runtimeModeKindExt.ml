type t = Data.RuntimeModeKind.t
open Data.RuntimeModeKind
       
let index_of =
  function | Find -> 0
           | Run  -> 1

let compare x y =
  compare (index_of x)
          (index_of y)
