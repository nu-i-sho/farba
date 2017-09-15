open Common

module Coord = struct
    module Map = Utils.IntPointMap   

    type t = int * int
           
    let move side (x, y) =
      if x mod 2 = 0
      then match side with | Up        -> (x    , y - 1)  
                           | LeftUp    -> (x - 1, y - 1)
                           | RightUp   -> (x + 1, y - 1)
                           | Down      -> (x    , y + 1)
                           | LeftDown  -> (x - 1, y    )
                           | RightDown -> (x + 1, y    )
      else match side with | Up        -> (x    , y - 1)
                           | LeftUp    -> (x - 1, y    )
                           | RightUp   -> (x + 1, y    )
                           | Down      -> (x    , y + 1) 
                           | LeftDown  -> (x - 1, y + 1)
                           | RightDown -> (x + 1, y + 1)  
  end
           
type t = { height : int;
            width : int;
           nucleo : Nucleus.t Coord.Map.t;
             cyto : Pigment.t Coord.Map.t;
             clot : Coord.t option
         }

let load src =
  let rec load_line cyto nucleo line y i l =
    if i == l then cyto, nucleo else
      let j = succ i in
      let k = succ j in
      let cyto, nucleo = 
        match line.[i] with
        | ' ' -> cyto, nucleo
        | chr -> let p = ((j / 3), y)
                 and cytoplasm = Pigment.of_char line.[i]
                 and nucleus = Nucleus.of_chars line.[j] line.[k] in
                 (Coord.Map.set p cytoplasm cyto),
                 (Coord.Map.set p nucleus nucleo) in
      load_line cyto nucleo line y k l in
  
  let rec load cyto nucleo y = function
    | h :: t -> let cyto, nucleo =
                  load_line cyto nucleo h y 0 (String.length h) in
                load cyto nucleo (succ y) t
    | []     -> {   clot = None;
                  height = src |> List.length;
                   width = src |> List.map String.length
                               |> List.fold_left max 0;
                  nucleo;
                    cyto
                } in

  load Coord.Map.empty
       Coord.Map.empty
       0
       src

let height o = o.height
let width  o = o.width
let clot   o = o.clot
             
let in_range (x, y) o =
  x < (width  o) &&
  y < (height o)
  
let out_of_range i o = 
  not (in_range i o)
  
let cytoplasm i o = Coord.Map.item i o.cyto
let nucleus   i o = Coord.Map.item i o.nucleo

let maybe_cytoplasm i o = Coord.Map.maybe_item i o.cyto
let maybe_nucleus   i o = Coord.Map.maybe_item i o.nucleo
                  
let set_nucleus i n o =
  { o with
    nucleo = Coord.Map.set i n o.nucleo
  }
  
let remove_nucleus i o =
  { o with
    nucleo = Coord.Map.remove i o.nucleo
  }

let set_clot c o =
  { o with clot = Some c
  }
