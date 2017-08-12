open Utils
open Data.Shared

type e = | Active of args
         | Static of args
                   
type t = e IntMap.t

let of_string = IntMap.of_string Args.of_string
let try_get = IntMap.maybe_item
let remove = IntMap.remove
let put = IntMap.put
