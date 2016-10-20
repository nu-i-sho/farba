open Data.Shared
open Utils

type e = | Active of dots * dots
         | Static of dots

type t = e IntMap.t

let item = IntMap.item
let maybe_item = IntMap.maybe_item

let of_string =
  let loop_of_string x = Static (Dots.of_string x) in
  IntMap.of_string loop_of_string
  
module Item = struct
    let iter i o =
      match item i o with

      | Static O
        -> o
         
      | Active (O, origin)
        -> o |> IntMap.put i (Static origin)
         
      | Static origin
        -> o |> IntMap.put i (Active ((Dots.pred origin), origin))

      | Active (current, origin)
        -> o |> IntMap.put i (Active ((Dots.pred current), origin)) 
  end
