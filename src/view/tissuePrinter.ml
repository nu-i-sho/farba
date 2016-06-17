module Make (Canvas : CANVAS.T)
             (Scale : TISSUE_SCALE.T) 
          (ColorFor : TISSUE_COLOR_SHEME.T) = struct
    
    open Scale

    type t = FloatPoint.t
    
    let zero = (0.0, 0.0)

    let set_index (x, y) _ = 
       let e = Hexagon.internal_radius in
       let i = Hexagon.external_radius in
       let y = y * 2 + (compare 1 (x mod 2)) in
       (i +. (float x) *. i *. 1.5), 
       (((float y) +. 1.0) *. e)

    let set_color c o = 
      let () = Graphics.set_color c in
      o

    let color_for_hels_pigment =
      function | HelsPigment.Blue -> ColorFor.blue_pigment
               | HelsPigment.Gray -> ColorFor.gray_pigment

    let color_for_pigment =
      function | Pigment.Blue -> ColorFor.blue_pigment
               | Pigment.Gray -> ColorFor.gray_pigment
               | Pigment.Red  -> ColorFor.cancer

    let set_hels_pigment_as_color p =
      set_color (color_for_hels_pigment p)

    let set_pigment_as_color p =
      set_color (color_for_pigment p)

    let set_opposited_pigment_as_color p =
      set_color @@ color_for_pigment
                @@ Pigment.opposite
                @@ p

    let set_color_for_cancer =
      set_color ColorFor.cancer

    let set_color_for_clot =
      set_color ColorFor.clot

    let set_color_for_virus =
      set_color ColorFor.virus

    let set_color_for_line =
      set_color ColorFor.line

    let apply_hexagon f o =
      Hexagon.agles |> Array.map (Pair.map float)
                    |> Array.map (Pair.foldl (+.) o)
                    |> Array.map (Pair.map Int.round)
                    |> f

    let draw_hexagon o =
      let () = apply_hexagon Canvas.draw_poly o in
      o

    let fill_hexagon o =
      let () = apply_hexagon Canvas.fill_poly o in
      o

    let apply_circle r f o =
      (o |> Pair.map Int.round
         |> f) r 

    let apply_nucleus =
      apply_circle Nucleus.radius
      
    let draw_nucleus o =
      let () = apply_nucleus Canvas.draw_circle o in
      o

    let fill_nucleus o =
      let () = apply_nucleus Canvas.fill_circle o in
      o

    let apply_hels_eyes f gaze o =
      gaze |> Nucleus.eyes_coords
           |> Pair.map (Pair.map float) 
           |> Pair.map (Pair.foldl (+.) o)
           |> Pair.map (apply_circle Nucleus.eyes_radius f)
           |> ignore

    let print_cross provide_lines gaze o =
      gaze |> provide_lines
           |> Pair.map (Pair.map (Pair.map float))
           |> Pair.map (Pair.map (Pair.foldl (+.) o))
           |> Pair.map (Pair.map (Pair.map Int.round))
           |> Pair.map (Pair.apply Canvas.moveto Canvas.lineto)
           |> ignore

    let draw_eyes eyes o =
      let () = 
	let open Eyes in
	match eyes with
	| Hels g    -> apply_hels_eyes Canvas.draw_circle g o
	| Clot g    -> print_cross Clot.eyes_coords g o
	| Cancer g  -> print_cross Cancer.eyes_coords g o
	| Cytoplasm -> 
	   let r = Cytoplasm.eyes_radius in
	   let p0, p1 = Cytoplasm.eyes_coords in   
	   let () = Canvas.draw_arc p0 r r 0 180 in
	   let () = Canvas.draw_arc p1 r r 0 180 in
	   ()
      in
      o

      
    let fill_eyes gaze o = 
      let () = apply_hels_eyes Canvas.fill_circle gaze o in
      o
    
  end
