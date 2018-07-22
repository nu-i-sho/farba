open Common

module CMap = Coord.Map

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

let height_of o = o.height
let width_of  o = o.width
let clot_of   o = o.clot
  
let is_clotted o = 
  match clot_f o with
  | Some _ -> true
  | None   -> false
  
let is_in (x, y) o =
  x < (width_of o) &&
  y < (height_of o)
  
let is_out_of i o =
  not (is_in i o)

let cytoplasm_at i o = CMap.find i o.cyto
let nucleus_at   i o = CMap.find i o.nucleo

let maybe_cytoplasm_at i o = CMap.find_opt i o.cyto
let maybe_nucleus_at   i o = CMap.find_opt i o.nucleo
        
let set item i o =
  match item with
  | Nucleus   x -> { o with nucleo = CMap.set i x o.nucleo }
  | Cytoplasm x -> { o with cyto   = CMap.set i x o.cyto }
  | Clot        -> { o with clot   = Some i }
        
let remove item i o =
  match item with
  | Nucleus   -> { o with nucleo = CMap.remove i o.nucleo }
  | Cytoplasm -> { o with cyto   = CMap.remove i o.cyto }
  | Clot      -> match clot_of o with
                 | Some clot when (Coord.equels i clot) 
                           -> { o with clot = None }
                 | Some _  -> o
                 | None    -> o

