module Make (Canvas : CANVAS.T)
             (Scale : TISSUE_SCALE.T) = struct
    
    open Scale

    type t = FloatPoint.t
    
    let zero = (0.0, 0.0)

    let set_index (x, y) _ = 
       let e = Hexagon.internal_radius in
       let i = Hexagon.external_radius in
       let y = y * 2 + lnot(x mod 2) in
       (i +. (float x) *. i *. 1.5), 
       (((float y) +. 1.0) *. e)

    let set_color c o = 
      let () = Graphics.set_color c in
      o

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

    let point_friendly f (x, y) =
      f x y

    let apply_circle r f o =
      (o |> Pair.map Int.round
         |> point_friendly f) r 

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
           |> Pair.map  (Pair.map (Pair.map float))
           |> Pair.map  (Pair.map (Pair.foldl (+.) o))
           |> Pair.map  (Pair.map (Pair.map Int.round))
           |> Pair.iter (Pair.apply 
			  (point_friendly Canvas.moveto)
                          (point_friendly Canvas.lineto))

    let draw_eyes eyes o =
      let () = 
	let open Eyes in
	match eyes with
	| Hels g    -> apply_hels_eyes Canvas.draw_circle g o
	| Clot g    -> print_cross Clot.eyes_coords g o
	| Cancer g  -> print_cross Cancer.eyes_coords g o
	| Cytoplasm -> 
	   let r = Cytoplasm.eyes_radius in
	   let (x0, y0), (x1, y1) = Cytoplasm.eyes_coords in   
	   let () = Canvas.draw_arc x0 y0 r r 0 180 in
	   let () = Canvas.draw_arc x1 y1 r r 0 180 in
	   ()
      in
      o
      
    let fill_eyes gaze o = 
      let () = apply_hels_eyes Canvas.fill_circle gaze o in
      o
    
  end
