module Fail = Data.Fail
   
type ('a, 'b) t = | Made of 'a
                  | Inited of 'b

let make state = Made state
let init state = Inited state
  
let made =
  function | Inited _   -> failwith Fail.cannot_reinit_state
           | Made state -> state
  
let inited =
  function | Made _       -> failwith Fail.state_is_not_inited
           | Inited state -> state
