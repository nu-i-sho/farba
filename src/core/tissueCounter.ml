open Data
open TissueStatistics

let calculate_for tissue =
  
  let h = Tissue.height tissue
  and w = Tissue.width  tissue
  and pigment_of =
    Nucleus.(
      function | Some { pigment = p; _ } -> Some p
               | None                    -> None
    ) in
  
  let flora = tissue |> Tissue.flora
                     |> Matrix.optional h w
  and fauna = tissue |> Tissue.fauna
                     |> Matrix.optional h w
                     |> Matrix.map pigment_of in
  
  let rec calc ((x, y) as i) acc =
    if y = h then acc else
      if x = w then calc (0, y + 1) acc else
        match (Matrix.get i flora),
              (Matrix.get i fauna) with

        |  None, _
        | (Some Pigment.White), None
           -> calc (x + 1, y) acc
        
        | (Some (Pigment.Blue | Pigment.Gray)), None
          -> let healthy_cells_capacity =
               acc.healthy_cells_capacity + 1 in
             calc (x + 1, y) { acc with healthy_cells_capacity }

        | (Some (Pigment.Blue | Pigment.Gray)),
          (Some (Pigment.Blue | Pigment.Gray))
          -> let healthy_cells = acc.healthy_cells + 1
             and healthy_cells_capacity =
               acc.healthy_cells_capacity + 1 in
             calc (x + 1, y) { acc with healthy_cells_capacity;
                                        healthy_cells
                             }
           
        | (Some (Pigment.Blue | Pigment.Gray)),
          (Some  Pigment.White)
          -> let cancer_cells = acc.cancer_cells + 1
             and healthy_cells_capacity =
               acc.healthy_cells_capacity + 1 in
             calc (x + 1, y) { acc with healthy_cells_capacity;
                                        cancer_cells
                             }

        | (Some Pigment.White), (Some _)
          -> let cancer_cells = acc.cancer_cells + 1 in
             calc (x + 1, y) { acc with cancer_cells }
  in

  let is_outed  = None = (Matrix.get (Tissue.weaver tissue) flora)
  and is_cloted = None <> (Tissue.clot tissue) in
  calc (0, 0) { healthy_cells_capacity = 0;
                         healthy_cells = 0;
                          cancer_cells = 0;
                             is_cloted;
                              is_outed;
              }
