open Utils

type die = Dots.t
type t = (int * (die ListOne.t)) ListOne.t

let top o =
  o |> ListOne.head
    |> snd

let top_index o =
  o |> ListOne.head
    |> fst
  
let top_dies o =
  o |> top
    |> ListOne.to_list
       
let top_die o =
  o |> top
    |> ListOne.head

let assoc i o = 
  o |> ListOne.assoc i
    |> snd
  
let dies i o =
  if o |> ListOne.mem_assoc i then
     o |> ListOne.assoc i
       |> ListOne.to_list else
    []

let die i o =
  o |> ListOne.assoc i
    |> ListOne.head
  
let maybe_die i o =
  match dies i o with
  | h :: _ -> Some h
  | []     -> None

