let calculate canvas_height canvas_width
              tissue_height tissue_width =

  let canvas_height = float canvas_height
  and canvas_width  = float canvas_width
  and tissue_height = float tissue_height
  and tissue_width  = float tissue_width
  in
  
  let max_horizontal_side =
    canvas_width  /. (tissue_width  *. 1.5 +. 0.5)
  and max_vertical_side =
    canvas_height /. (tissue_height *. 2.0 +. 1.0)
                  /. Const.sqrt_3_div_2
  in
  
  min max_horizontal_side
      max_vertical_side
