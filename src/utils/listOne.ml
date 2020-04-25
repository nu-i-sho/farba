type 'e t = 'e * ('e list)

let to_list (h, t) = h :: t
let of_list (h :: t) = h, t
  
let hd = fst
let tl o =
  o |> snd
    |> of_list

let last (h, t) =
  match t with
  | [] -> h
  | t  -> List.(hd (rev t))

let map f (h, t) =
  (f h), (List.map f t)
           
let assoc key ((k, v), t) =
  if key = k then v else
    List.assoc key t

let mem_assoc key ((k, v), t) =
  key = k || (List.mem_assoc key t)
