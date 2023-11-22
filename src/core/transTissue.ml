module Make = functor (Original : TISSUE.T) ->
struct

  module HexSet = Set.Make(HexCoord)

  type t =
    { original : Original.t;
       changes : HexSet.t
    }

  let open' tissue =
    { original = tissue;
       changes = HexSet.empty
    }

  include (Tissue.Cover(Original)(struct
     type nonrec t = t
           
      let original o = o.original
      let map_original f o =
        { o with
          original = f o.original
        }                            end) : TISSUE.T with type t := t)
       
  let track i o =
    { o with
      changes = HexSet.add i o.changes
    }
  
  let add_cytoplasm  i x o = o |> track i |> add_cytoplasm i x
  let add_nucleus    i x o = o |> track i |> add_nucleus i x
  let remove_cytoplasm i o = o |> track i |> remove_cytoplasm i
  let remove_nucleus   i o = o |> track i |> remove_nucleus i

  let cell_is_resolved i tissue =
    let o = tissue in
    match o |> Dead.cytoplasm_opt i with
    | Some `Closed                                             -> true
    | None -> match o |> Dead.nucleus_opt i with
              | Some (`Clot _)                                 -> false
              | None -> match (o |> Alive.cytoplasm_opt i), 
                              (o |> Alive.nucleus_opt i) with
                        | (Some `FinalG), (Some (`HealthyB _))
                        | (Some `FinalB), (Some (`HealthyG _))
                        | (Some `Trans ),  None                -> true
                        |  _                                   -> false
                          
  let close o =
    let with_check_update i o =
      if o |> cell_is_resolved i then
         o |> resolve  i else
         o |> dissolve i in
    (HexSet.fold
       with_check_update
       o.changes
       o)
    .original 
  end
