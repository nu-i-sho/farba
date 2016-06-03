type t = | Cytoplazm of HelsPigment.t
         | Celluar of Celluar.t

let replicate relationship ~donor:d ~acceptor:a =
  let wrapp_to_celluars (x, y) =
    (Celluar x), (Celluar y)
  in

  ( match a with
    | None               -> Celluar.replicate relationship d
    | Some (Cytoplazm c) -> Celluar.replicate_to_cytoplazm 
  			      relationship
			          ~donor:d
			       ~acceptor:c
    | Some (Celluar c)   -> Celluar.replicate_to_celluar 
			      relationship
			          ~donor:d
			       ~acceptor:c
  ) |> wrapp_to_celluars
