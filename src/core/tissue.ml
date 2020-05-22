module Coord = struct
  type t = int * int
         
  module Map =
    Map.Make (
        struct type t = int * int
               let compare (x1, y1) (x2, y2) =
                 match  compare y1 y2 with
                 | 0 -> compare x1 x2
                 | x -> x
               end)
  
  let move side (x, y) =
    let dx, dy =
      match x mod 2, side with
        
      | 0, Side.Up        ->  0, -1  
      | 0, Side.LeftUp    -> -1, -1
      | 0, Side.RightUp   -> +1, -1
      | 0, Side.Down      ->  0, +1
      | 0, Side.LeftDown  -> -1,  0
      | 0, Side.RightDown -> +1,  0
                             
      | 1, Side.Up        ->  0, -1
      | 1, Side.LeftUp    -> -1,  0
      | 1, Side.RightUp   -> +1,  0
      | 1, Side.Down      ->  0, +1 
      | 1, Side.LeftDown  -> -1, +1
      | 1, Side.RightDown -> +1, +1
                           
      | _        -> assert false in
    
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
  | None   -> assert false

let set_clot  i o = { o with clot = Some i }
let remove_clot o = { o with clot = None   }
  
let cytoplasm     i o = o.cytoplasms |> Coord.Map.find i 
let cytoplasm_opt i o = o.cytoplasms |> Coord.Map.find_opt i
let cytoplasms      o = o.cytoplasms |> Coord.Map.to_seq

let add_cytoplasm i x o =
  let c = Coord.Map.set i x o.cytoplasms in
  { o with cytoplasms = c
  }

let remove_cytoplasm i o =
  let c = Coord.Map.remove i o.cytoplasms in
  { o with cytoplasms = c
  }
   
let nucleus     i o = o.nucleuses |> Coord.Map.find i
let nucleus_opt i o = o.nucleuses |> Coord.Map.find_opt i
let nucleuses     o = o.nucleuses |> Coord.Map.to_seq 

let set_nucleus i x o =
  let n = Coord.Map.set i x o.nucleuses in 
  { o with nucleuses = n 
  }

let remove_nucleus i o =
  let n = Coord.Map.remove i o.nucleuses in
  { o with nucleuses = n
  }
