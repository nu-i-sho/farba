module Make = functor (Tissue : TISSUE.RESOLVABLE.T) ->
struct

  module HexSet = Set.Make(HexCoord)

  type cytoplasm_t = Cytoplasm.t
  type nucleus_t = Nucleus.t
  type virus_t = Virus.t

  type t =
    { original : Tissue.t;
       changes : HexSet.t
    }

  let open' tissue =
    { original = tissue;
       changes = HexSet.empty
    }
    
  let is_resolved i tissue =
    let o = tissue in
    match o |> Tissue.Dead.cytoplasm_opt i with
    | Some `Closed                                                   -> true
    | None -> match o |> Tissue.Dead.nucleus_opt i with
              | Some (`Clot _)                                       -> false
              | None -> match (o |> Tissue.Alive.cytoplasm_opt i), 
                              (o |> Tissue.Alive.nucleus_opt i) with
                        | (Some `FinalG), (Some (`HealthyB _))
                        | (Some `FinalB), (Some (`HealthyG _))
                        | (Some `Trans ),  None                      -> true
                        |  _                                         -> false

  module WithTracking =
    functor (Layer : LAYER.T with type t = Tissue.t) ->
     struct
       type cytoplasm_t = Layer.cytoplasm_t
       type nucleus_t = Layer.nucleus_t                      
       type nonrec t = t
      
        let cytoplasm_opt i o = o.original |> Layer.cytoplasm_opt i
        let nucleus_opt   i o = o.original |> Layer.nucleus_opt i    
        let cytoplasm     i o = o.original |> Layer.cytoplasm i
        let nucleus       i o = o.original |> Layer.nucleus i

        let change i map o =
          { original = map o.original;
             changes = HexSet.add i o.changes
          } 
        
        let add_cytoplasm  i x o = o |> change i (Layer.add_cytoplasm i x)
        let add_nucleus    i x o = o |> change i (Layer.add_nucleus i x)
        let remove_cytoplasm i o = o |> change i (Layer.remove_cytoplasm i)
        let remove_nucleus   i o = o |> change i (Layer.remove_nucleus i)
        end

  module Alive = WithTracking(Tissue.Alive)
  module Dead  = WithTracking(Tissue.Dead)

  include (WithTracking(Tissue) :
             LAYER.T with type t := t
                      and type cytoplasm_t := Cytoplasm.t
                      and type nucleus_t := Nucleus.t)

  let virus_opt i o = o.original |> Tissue.virus_opt i
  let virus     i o = o.original |> Tissue.virus i

  let change map o = { o with original = map o.original }
      
  let add_virus  i x o = o |> change (Tissue.add_virus i x)
  let remove_virus i o = o |> change (Tissue.remove_virus i)
 
  let viruses predicate o =
    o.original |> Tissue.viruses predicate

  let close o =
    let with_check_update i tissue =
      if tissue |> is_resolved i then
         tissue |> Tissue.resolve i else
         tissue |> Tissue.dissolve i in
    HexSet.fold with_check_update o.changes o.original 
  end
