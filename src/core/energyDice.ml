open Utils
open Data
   
type t = { dies : (int * (Dots.t ListOne.t)) ListOne.t;
           mode : Die.mode;
         }

let origin =
  { dies = (0, (Dots.O, [])), [];
    mode = Die.Stay;
  }
  
let top_mode o = o.mode             
let with_top_mode m o =
  { o with mode = m
  }
               
let top_index o =
  o.dies |> ListOne.head
         |> fst

let top_die o =
  Die.({       mode = o.mode;
         generation = o.dies |> ListOne.head
                             |> snd
                             |> ListOne.head;
       })

let to_stay_die dots =
  Die.({ generation = dots;
               mode = Stay;
       })
  
let top_dies o =
  let (_, (h, t)), _ = o.dies in
  Die.({ generation = h;
               mode = o.mode;
       }) :: (List.map to_stay_die t)

let dies i o =
  if (top_index o) = i then
    top_dies o else
    if o.dies |> ListOne.mem_assoc i then
       o.dies |> ListOne.assoc i
              |> ListOne.to_list
              |> List.map to_stay_die else
      []
     
let die i o =
  if (top_index o) = i then
    top_die o else
    o.dies |> ListOne.assoc i
           |> ListOne.head
           |> to_stay_die

let maybe_die i o =
  match dies i o with
  | h :: _ -> Some h
  | []     -> None
