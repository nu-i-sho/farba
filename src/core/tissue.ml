module HexMap = Map.Make(HexCoord)
module HexSet = Set.Make(HexCoord)

type t =
  {  cytoplasm : Cytoplasm.t HexMap.t;
        nuclei : Nucleus.t HexMap.t;
       viruses : Virus.t HexMap.t;
    unresolved : HexSet.t
  }

let cytoplasm_opt i o = o.cytoplasm |> HexMap.find_opt i
let nucleus_opt   i o =    o.nuclei |> HexMap.find_opt i
let virus_opt     i o =   o.viruses |> HexMap.find_opt i
let cytoplasm     i o = o.cytoplasm |> HexMap.find i
let nucleus       i o =    o.nuclei |> HexMap.find i
let virus         i o =   o.viruses |> HexMap.find i

let viruses_coords v o = 
  let predicate _ x = v = x
  and coord (i, _) = i in
  o.viruses |> HexMap.filter predicate 
            |> HexMap.bindings
            |> List.map coord

let is_resolved o =
  HexSet.is_empty o.unresolved

module Alive = struct
   let cytoplasm_opt i o = Option.bind (cytoplasm_opt i o) Cytoplasm.to_alive_opt             
   let nucleus_opt   i o = Option.bind (nucleus_opt i o)   Nucleus.to_alive_opt
   let cytoplasm     i o = Option.get  (cytoplasm_opt i o)
   let nucleus       i o = Option.get  (nucleus_opt i o)
   end

module Dead = struct
   let cytoplasm_opt i o = Option.bind (cytoplasm_opt i o) Cytoplasm.to_dead_opt
   let nucleus_opt   i o = Option.bind (nucleus_opt i o)   Nucleus.to_dead_opt
   let cytoplasm     i o = Option.get  (cytoplasm_opt i o) 
   let nucleus       i o = Option.get  (nucleus_opt i o)
   end

let add_cytoplasm  i x o = { o with cytoplasm = HexMap.add  i x o.cytoplasm }
let add_nucleus    i x o = { o with nuclei    = HexMap.add  i x o.nuclei    }
let add_virus      i x o = { o with viruses   = HexMap.add  i x o.viruses   }
let remove_cytoplasm i o = { o with cytoplasm = HexMap.remove i o.cytoplasm }
let remove_nucleus   i o = { o with nuclei    = HexMap.remove i o.nuclei    }
let remove_virus     i o = { o with viruses   = HexMap.remove i o.viruses   }

let resolve  i o = { o with unresolved = HexSet.remove i o.unresolved }
let dissolve i o = { o with unresolved = HexSet.add    i o.unresolved }          

module ReadOnly = struct
  module CoverSub =
    functor (Original : TISSUE.READ_ONLY.SUB.T) ->
    functor (Seed : TISSUE.READ_ONLY.COVER_SEED.T
             with type original_t := Original.t) ->
     struct
       type t = Seed.t

        let get =  Seed.original
        let cytoplasm_opt i o = o |> get |> Original.cytoplasm_opt i
        let nucleus_opt   i o = o |> get |> Original.nucleus_opt i    
        let cytoplasm     i o = o |> get |> Original.cytoplasm i
        let nucleus       i o = o |> get |> Original.nucleus i
        end

  module Cover =
    functor (Original : TISSUE.READ_ONLY.T) ->
    functor (Seed : TISSUE.READ_ONLY.COVER_SEED.T
             with type original_t := Original.t) ->
     struct
        include CoverSub(struct
            include Original
               type cytoplasm_t = Cytoplasm.t
               type nucleus_t = Nucleus.t
               end)(Seed)

        let get =  Seed.original
        let viruses_coords v o = o |> get |> Original.viruses_coords v
        let virus_opt      i o = o |> get |> Original.virus_opt i
        let virus          i o = o |> get |> Original.virus i
        let is_resolved      o = o |> get |> Original.is_resolved

        module Alive = CoverSub(struct
            include Original.Alive
               type cytoplasm_t = Cytoplasm.Alive.t
               type nucleus_t = Nucleus.Alive.t
               type t = Original.t
               end)(Seed)

        module Dead = CoverSub(struct
            include Original.Dead
               type cytoplasm_t = Cytoplasm.Dead.t
               type nucleus_t = Nucleus.Dead.t
               type t = Original.t
               end)(Seed)
        end
  end

module Cover =
  functor (Original : TISSUE.T) ->
  functor (Seed : TISSUE.COVER_SEED.T
           with type original_t := Original.t) ->
   struct
     include ReadOnly.Cover(Original)(Seed)

      let map = Seed.map_original
      let add_cytoplasm  i x o = o |> map (Original.add_cytoplasm i x)
      let add_nucleus    i x o = o |> map (Original.add_nucleus i x)
      let add_virus      i x o = o |> map (Original.add_virus i x)
      let remove_cytoplasm i o = o |> map (Original.remove_cytoplasm i)
      let remove_nucleus   i o = o |> map (Original.remove_nucleus i)
      let remove_virus     i o = o |> map (Original.remove_virus i)
      let resolve          i o = o |> map (Original.resolve i)
      let dissolve         i o = o |> map (Original.dissolve i)
      end  
