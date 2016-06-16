type t = Command.t array

let get i o = o.(i)
let length = Array.length

let load src =

  let sep = String.index src ' ' in
  let count = int_of_string (String.sub src 0 (sep + 1)) in
  let program = Array.make (count + 1) Command.End in
  let save i c = if i > sep then 
		   program.(i) <- Command.of_char c else
		   ()
  in

  let () = String.iteri save src in
  program
