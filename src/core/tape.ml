open Common
open Utils

type e = | Command of command
         | OutOfRange of hand
           
type t = { storage : command IntMap.t;
            length : int
         }

let make src =
  {  length = List.length src;
    storage = src |> List.mapi Pair.make
                  |> IntMap.of_bindings 
  }

let length o = o.length 
let get i o =
  if i < 0 then OutOfRange Left else
    if i >= o.length then OutOfRange Right else
      Command (IntMap.find i o.storage)
  
let set i cmd o =
  { o with
    storage = IntMap.set i cmd o.storage
  }
