module Coord = struct
  module Map = Map.MakePair (Int) (Int)
  type t = int * int
         
  let move side (x, y) =
    let dx, dy = Side.(
        match x mod 2, side with
          
        | 0, Up        ->  0, -1  
        | 0, LeftUp    -> -1, -1
        | 0, RightUp   -> +1, -1
        | 0, Down      ->  0, +1
        | 0, LeftDown  -> -1,  0
        | 0, RightDown -> +1,  0
                             
        | _, Up        ->  0, -1
        | _, LeftUp    -> -1,  0
        | _, RightUp   -> +1,  0
        | _, Down      ->  0, +1 
        | _, LeftDown  -> -1, +1
        | _, RightDown -> +1, +1 ) in
    
    x + dx,
    y + dy
  end

type t = {  nucleuses : Nucleus.t Coord.Map.t;
           cytoplasms : Pigment.t Coord.Map.t;
                 clot : Coord.t option
         }
       
let empty =
  {  nucleuses = Coord.Map.empty;
    cytoplasms = Coord.Map.empty;
          clot = None
  }
  
let is_in     i o = Coord.Map.mem i o.cytoplasms
let is_out_of i o = not (is_in i o)
   
let clot_opt o = o.clot
let has_clot o = 
  match o.clot with
  | Some _ -> true
  | None   -> false

let clot o =
  match o.clot with
  | Some x -> x
  | None   -> failwith "no clot"

let set_clot  i o = { o with clot = Some i }
let remove_clot o = { o with clot = None   }
  
let cytoplasm     i o = Coord.Map.find i o.cytoplasms
let cytoplasm_opt i o = Coord.Map.find_opt i o.cytoplasms
                      
let set_cytoplasm i x o =
  let c = Coord.Map.set i x o.cytoplasms in
  { o with cytoplasms = c
  }

let remove_cytoplasm i o =
  let c = Coord.Map.remove i o.cytoplasms in
  { o with cytoplasms = c
  }
   
let nucleus     i o = Coord.Map.find i o.nucleuses
let nucleus_opt i o = Coord.Map.find_opt i o.nucleuses

let set_nucleus i x o =
  let n = Coord.Map.set i x o.nucleuses in 
  { o with nucleuses = n 
  }
 
let remove_nucleus i o =
  let n = Coord.Map.remove i o.nucleuses in
  { o with nucleuses = n
  }
