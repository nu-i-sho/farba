type 'e t = 'e list

let rec maybe_last =
  function | h :: [] -> Some h
           | _ :: t  -> maybe_last t
           | []      -> None
                         
let last o =
  match maybe_last o with
  | Some x -> x
  | None   -> raise Not_found
