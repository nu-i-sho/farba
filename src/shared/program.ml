type t = Command.t array

let get i o = o.(i)
let length = Array.length

let load src =
  let length = (String.length src) + 1 in
  let parse_cmd i =
    if i < length - 1 then 
      Command.of_char src.[i] else
      Command.End
  in

  Array.init length parse_cmd
