module Dots = DotsOfDice

type t = (Dots.t * int) list

let start        = [Dots.O, 0]
let last_pair    = List.hd 
let last o       = fst (last_pair o)
let last_place o = snd (last_pair o)  
let count        = List.length
let length     o = (last_place o) + 1
let is_empty     = (=) []

let increment ((a, x) :: t) = (a, x + 1) :: t

let decrement = 
  function | (_, x) :: (b, y) :: t 
		when (x - 1) = y -> (b, y) :: t
           | [_, 0]              -> []
           | (a, x) :: t         -> (a, x - 1) :: t

let split ((a, x) :: t) = 
  (Dots.increment a, x + 1) :: (a, x) :: t
