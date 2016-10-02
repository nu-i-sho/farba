open Data.Shared
open Data.Tissue
open Data.Statistics.Tissue
open Utils

type t = Data.Statistics.Tissue.t
   
let calculate_for tissue =
  
  let h = Tissue.height tissue
  and w = Tissue.width  tissue
  and pigment =
      function | Some { pigment = p; _ } -> Some p
               | None                    -> None in
  
  let flora = tissue |> Tissue.flora
                     |> Matrix.optional h w
  and fauna = tissue |> Tissue.fauna
                     |> Matrix.optional h w
                     |> Matrix.map pigment in
  
  let rec calc x y acc =
    if y = h then acc else
      if x = w then calc 0 (succ y) acc else

        ( match (Matrix.get (x, y) flora),
                (Matrix.get (x, y) fauna) with
            
          | (Some (Blue | Gray)), None
            -> { acc with healthy_cells_capacity =
                            succ acc.healthy_cells_capacity
               }

          | (Some (Blue | Gray)), (Some (Blue | Gray))
            -> { acc with healthy_cells_capacity =
                            succ acc.healthy_cells_capacity;
                                   healthy_cells =
                                     succ acc.healthy_cells
               }
           
          | (Some (Blue | Gray)), (Some  White)
            -> { acc with healthy_cells_capacity =
                            succ acc.healthy_cells_capacity;
                                    cancer_cells =
                                      succ acc.cancer_cells     
               }

          | (Some White), (Some _)
            -> { acc with cancer_cells =
                            succ acc.cancer_cells
               }

          |  None, _
          | (Some White), None
            -> acc
              
        ) |> calc (succ x) y
  in

  let is_outed  = None = (Matrix.get (Tissue.weaver tissue) flora)
  and is_cloted = None <> (Tissue.clot tissue) in
  calc 0 0 { healthy_cells_capacity = 0;
                      healthy_cells = 0;
                       cancer_cells = 0;
                          is_cloted;
                           is_outed
           }
