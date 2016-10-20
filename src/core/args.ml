open Utils.Primitives
open Shared.Fail
open Data.Shared

type t = args

let of_string x =
  let arg i = Arg.of_char x.[i] in
  
  Tripleable.(
    match String.length x with
    | 1 -> Single  (arg 0)
    | 2 -> Double ((arg 0), (arg 1)) 
    | 3 -> Triple ((arg 0), (arg 1), (arg 2))
    | _ -> raise (Inlegal_case "Core.Args.of_string")
  )
