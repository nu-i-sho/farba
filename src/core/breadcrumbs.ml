type t = (DotsOfDice.t * int) Stack.t

let start =
  let o  = Stack.create () in
  let () = Stack.push (DotsOfDice.O, 0) o in
  o

let last_pair    = Stack.pop 
let last       o = fst (last_pair o)
let last_place o = snd (last_pair o)  
let count        = Stack.length
let length     o = (last_place o) + 1
let is_empty     = Stack.is_empty

let increment o =
  let (crumb, place) = Stack.pop o in
  let () = Stack.push (crumb, place + 1) o in
  o

let decrement o =
  let crumb_1, place_1 = Stack.pop o in
  let crumb_0, place_0 = Stack.top o in
  let place_1 = place_1 - 1 in
  if place_1 = place_0 then o else
    let () = Stack.push (crumb_1, place_1) o in
    o

let split o =
  let crumb_0, place_0 = Stack.top o in
  let crumb_1 = crumb_0 |> DotsOfDice.increment in
  let place_1 = place_0 + 1 in
  let () = Stack.push (crumb_1, place_1) o in
  o
