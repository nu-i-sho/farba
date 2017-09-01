open Data

type die = Die.energy
type t = { breadcrumbs : EnergyDots.t;
                  mode : Die.mode;
         }
  
let top_index o =
  EnergyDots.top_index o.breadcrumbs

let top_mode o =
  o.mode

let with_top_mode m o =
  { o with mode = m
  }
  
let top_die o =
  Die.({ generation = EnergyDots.top_die o.breadcrumbs;
               mode = top_mode o;
       })

let to_stay_die dots =
  Die.({ generation = dots;
               mode = Stay;
       })
  
let top_dies o =
  let dots = EnergyDots.top_dies o.breadcrumbs in
  Die.({ generation = List.hd dots;
               mode = top_mode o;
       }) :: (dots |> List.tl
                   |> List.map to_stay_die)

let dies i o =
  if i = (top_index o) then
    top_dies o else
    o.breadcrumbs |> EnergyDots.dies i
                  |> List.map to_stay_die

let die i o =
  if i = (top_index o) then
    top_die o else
    o.breadcrumbs |> EnergyDots.die i
                  |> to_stay_die

let maybe_die i o =
  match dies i o with
  | h :: _ -> Some h
  | []     -> None
