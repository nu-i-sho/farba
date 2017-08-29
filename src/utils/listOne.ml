type 'e t = 'e * ('e list)

let to_list (h, t) = h :: t
let of_list (h :: t) = h, t
  
let head = fst
let tail o =
  o |> snd
    |> of_list
