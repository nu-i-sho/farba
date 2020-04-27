module Coord = struct
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

  let compare a b =
    match  compare (fst a) (fst b) with
    | 0 -> compare (snd a) (snd b)
    | o -> o
             
  end

             
module CMap = Utils.MapExt.Make (Coord)
             
type t = {  nucleuses : Nucleus.t CMap.t;
           cytoplasms : Pigment.t CMap.t;
                 clot : Coord.t option
         }
       
let empty =
  {  nucleuses = CMap.empty;
    cytoplasms = CMap.empty;
          clot = None
  }
  
(*
let load src =
  let rec load_line cyto nucleo line y i l =
    if i == l then cyto, nucleo else
      let j = succ i in
      let k = succ j in
      let cyto, nucleo = 
        match line.[i] with
        | ' ' -> cyto, nucleo
        | chr -> let p = ((j / 3), y)
                 and c = Pigment.of_char  line.[i]
                 and n = Nucleus.of_chars line.[j] line.[k] in
                 (cyto   |> set p (Cytoplasm c))
                 (nucleo |> set p (Nucleus c) in
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

  load CMap.empty
       CMap.empty
       0
       src
*)

let is_in     i o = CMap.mem i o.cytoplasms
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
  
let cytoplasm     i o = CMap.find i o.cytoplasms
let cytoplasm_opt i o = CMap.find_opt i o.cytoplasms
                      
let set_cytoplasm i x o =
  let c = CMap.set i x o.cytoplasms in
  { o with cytoplasms = c
  }

let remove_cytoplasm i o =
  let c = CMap.remove i o.cytoplasms in
  { o with cytoplasms = c
  }
   
let nucleus     i o = CMap.find i o.nucleuses
let nucleus_opt i o = CMap.find_opt i o.nucleuses

let set_nucleus i x o =
  let n = CMap.set i x o.nucleuses in 
  { o with nucleuses = n 
  }
 
let remove_nucleus i o =
  let n = CMap.remove i o.nucleuses in
  { o with nucleuses = n
  }
