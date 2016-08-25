open Data
open Tools
   
type t = { height : int;
            width : int;
           weaver : int * int;
             clot : ((int * int) * Side.t) option;
	    flora : Pigment.t IntPointMap.t;
            fauna : Nucleus.t IntPointMap.t;
             init : t option
	 }

let load level =
  let state = { height = level |> Level.height;
                 width = level |> Level.width;
                weaver = level |> Level.active;
                 flora = level |> Level.flora;
                 fauna = level |> Level.fauna;
                  clot = None;
                  init = None
              } in
  { state with init = Some state }

let height o = o.height
let width  o = o.width
let flora  o = o.flora
let fauna  o = o.fauna
let clot   o = o.clot
let weaver o = o.weaver

let with_fauna  x o = { o with fauna = x }
let with_weaver x o = { o with weaver = x }
let with_clot i x o = { o with clot = Some (i, x) }

let cell c n =
  Cell.({ cytoplasm = c;
            nucleus = n;
       })

let to_item =
  TissueItem.((* (cytoplasm, nucleus), (clot, is_active) *)
    function |  _, ((Some gaze), _)             -> Clot gaze
             | (None, None), _                  -> Out
             | (None, (Some n)), _              -> Outed n
             | ((Some c), None), _              -> Cytoplasm c
             | ((Some c), (Some n)), (_, true)  -> Active (cell c n)
             | ((Some c), (Some n)), (_, false) -> Static (cell c n)
  )

let to_init_item =
  TissueItemInit.((* (cytoplasm, nucleus), is_active *)
    function | (None, _), _                -> Out
             | ((Some c), None), _         -> Cytoplasm c
             | ((Some c), (Some n)), true  -> Active (cell c n)
             | ((Some c), (Some n)), false -> Static (cell c n)
  )

let flora_matrix o =
  Matrix.optional o.height o.width o.flora
  
let fauna_matrix o =
  Matrix.optional o.height o.width o.fauna

let weaver_matrix o =
  (IntPointMap.singleton o.weaver true)
     |> Matrix.of_map o.height o.width false

let clot_matrix o =
  match o.clot with
  | None           -> Matrix.empty o.height o.width None
  | Some (i, gaze) -> (Some gaze)
                         |> IntPointMap.singleton i
                         |> Matrix.of_map o.height o.width None
let init_items o =
  match o.init with
  | None   ->  Matrix.empty 0 0 TissueItemInit.Out 
  | Some o -> (Matrix.zip (Matrix.zip (flora_matrix  o)
                                      (fauna_matrix  o))
                                      (weaver_matrix o))
                 |> Matrix.map to_init_item
let items o =
  (Matrix.zip (Matrix.zip (flora_matrix  o)
                          (fauna_matrix  o))
              (Matrix.zip (clot_matrix   o)
                          (weaver_matrix o)))
     |> Matrix.map to_item
