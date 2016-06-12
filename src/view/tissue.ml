module Make (ColorFor : TISSUE_COLOR_SHEME.T)
            (Canvas   : CANVAS.T) = struct
   
    type t = Hexagon.t

    let print_empty i o =
      let () = Canvas.set_color ColorFor.line in
      o |> Hexagon.angles_coords i
        |> Canvas.draw_poly

    let print_cyto i pigment o =
      let () = HelsPigment.( match pigment with
                             | Blue -> ColorFor.blue_pigment
                             | Gray -> ColorFor.gray_pigment
                           ) |> Canvas.set_color in

      o |> Hexagon.angles_coords i
        |> Canvas.fill_poly

    let print_cell i cell o =
      match Protocell.kind_of cell with
      
      | CellKind.Clot ->
	 let () = Canvas.set_color ColorFor.clot in
	 let () =  o |> Hexagon.angles_coords i
                     |> Canvas.draw_poly
	 in
	 
	 let ((l1_x1, l1_y1), (l1_x2, l1_y2)),
	     ((l2_x1, l2_y1), (l2_x2, l2_y2)) = 
	   Clot.eyes_coords i cell.gaze o
	 in

	 let () = Canvas.set_color ColorFor.line in
	 let () = Canvas.moveto l1_x1 l1_y1 in
	 let () = Canvas.lineto l1_x2 l1_y2 in
	 let () = Canvas.moveto l2_x1 l2_y1 in
	 let () = Canvas.lineto l2_x2 l2_y2 in
	 ()
     
      | CellKind.Cancer ->
	 let x, y = Hexagon.center_coord i o in
	 let n = Nucleus.make o in
	 let r = Nucleus.radius n in

	 let () = Canvas.set_color ColorFor.line in
	 let () = Canvas.draw_circle x y r in
	 let () = Canvas.set_color ColorFor.cancer in
	 let () = Canvas.fill_circle x y r in 

	 let ((l1_x1, l1_y1), (l1_x2, l1_y2)),
	     ((l2_x1, l2_y1), (l2_x2, l2_y2)) = 
	   Nucleus.cancer_eyes_coords i cell.gaze n
	 in
	 
	 let () = Canvas.set_color ColorFor.line in
	 let () = Canvas.moveto l1_x1 l1_y1 in
	 let () = Canvas.lineto l1_x2 l1_y2 in
	 let () = Canvas.moveto l2_x1 l2_y1 in
	 let () = Canvas.lineto l2_x2 l2_y2 in
	 ()

      | CellKind.Hels -> 
	 let x, y = Hexagon.center_coord i o in
	 let n = Nucleus.make o in
	 let r = Nucleus.radius n in

         let () = Canvas.set_color ColorFor.line in
	 let () = Canvas.draw_circle x y r in
	 let () = Pigment.( match cell.pigment with
			    | Blue -> ColorFor.blue_pigment
			    | Gray -> ColorFor.gray_pigment
                          ) |> Canvas.set_color in
	 let () = Canvas.fill_circle x y r in

	 let eyes_color = Pigment.opposite cell.pigment in
	 let r = Nucleus.eye_radius n in
	 let (x1, y1), (x2, y2) = 
	   Nucleus.eyes_coords i cell.gaze n
	 in
	 
	 let () = Canvas.set_color ColorFor.line in
	 let () = Canvas.draw_circle x1 y1 r in
	 let () = Canvas.draw_circle x2 y2 r in
	 let () = Pigment.( match eyes_color with
			    | Blue -> ColorFor.blue_pigment
			    | Gray -> ColorFor.gray_pigment
                          ) |> Canvas.set_color in 
	 let () = Canvas.fill_circle x1 y1 r in
	 let () = Canvas.fill_circle x2 y2 r in
	 ()
	
    let print_diff i 
         ~previous:_
          ~current:c
                   o = print_cell i c o

  end
