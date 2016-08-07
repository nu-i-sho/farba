type t = { height : int;
            width : int;
           weaver : int * int;
             clot : ((int * int) * Side.t) option;
	    flora : Pigment.t Index.Map.t;
            fauna : Nucleus.t Index.Map.t
	 }

let load level =
  { height = level |> Level.height;
     width = level |> Level.width;
    weaver = level |> Level.active;
     flora = level |> Level.flora;
     fauna = level |> Level.fauna;
      clot = None
  }

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
  Data.Cell.({ cytoplasm = c;
                 nucleus = n;
             })

let to_item x =
  Data.TissueItem.(
    match x with
   (* (cytoplasm, nucleus), (clot, is_active) *)
    |  _, ((Some gaze), _)             -> Clot gaze
    | (None, None), _                  -> Out
    | (None, (Some n)), _              -> Outed n
    | ((Some c), None), _              -> Cytoplasm c
    | ((Some c), (Some n)), (_, true)  -> Active (cell c n)
    | ((Some c), (Some n)), (_, false) -> Static (cell c n)
  )

let items o =
  let h = o.height
  and w = o.width in
  let flora  = Matrix.optional h w o.flora
  and fauna  = Matrix.optional h w o.fauna
  and weaver = (Index.Map.singleton o.weaver true)
               |> Matrix.of_map h w false
  and clot   = match o.clot with
               | None           -> Matrix.empty h w None
               | Some (i, gaze) ->
		  (Some gaze) |> Index.Map.singleton i
                              |> Matrix.of_map h w None in

  let flora_fauna = Matrix.zip flora fauna
  and clot_weaver = Matrix.zip clot weaver in
  (Matrix.zip flora_fauna clot_weaver)
     |> Matrix.map to_item
