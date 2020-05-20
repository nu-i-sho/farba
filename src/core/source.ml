type e = (Command.t, Dots.t, Dots.t) Statement.t
type t = e list

let bindings =
  let dots_bindings =
    let bind i x =
      (i |> succ
         |> (+) (Char.code '0')
         |> Int.to_string
      ), x in
    List.mapi bind Dots.all

  and bind_call    (i, x) = ("C" ^ i), (Statement.Call x)
  and bind_declare (i, x) = ("D" ^ i), (Statement.Declare x) in
  
  [ "PTL", Statement.Perform (Command.Turn Hand.Left);
    "PTR", Statement.Perform (Command.Turn Hand.Right);
    "PMB", Statement.Perform (Command.Move Nature.Body);
    "PMM", Statement.Perform (Command.Move Nature.Mind);
    "PRD", Statement.Perform (Command.Replicate Gene.Dominant);
    "PRR", Statement.Perform (Command.Replicate Gene.Recessive)
  ]
  @ (dots_bindings |> List.map bind_call)
  @ (dots_bindings |> List.map bind_declare)
       
let of_string str =
  let find_in = Fun.flip List.assoc in
  try str |> String.split_on_char ' '
          |> List.map (find_in bindings) 
  with Not_found -> raise (Invalid_argument str) 
  
let to_string o =
  let is_for_statement x (_, y) = x = y
  and find_in = Fun.flip List.find in
  o |> List.map is_for_statement
    |> List.map (find_in bindings)
    |> List.map fst
    |> String.concat " "
