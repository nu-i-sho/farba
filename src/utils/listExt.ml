type 'e t = 'e list

(* TODO: remove it after 
         update OCaml to 4.05 *)
let find_opt f o =
  try
    Some (List.find f o)
  with Not_found ->
    None

let rec last_opt =
  function | h :: [] -> Some h
           | _ :: t  -> last_opt t
           | []      -> None
                         
let last o =
  match last_opt o with
  | Some x -> x
  | None   -> raise Not_found
