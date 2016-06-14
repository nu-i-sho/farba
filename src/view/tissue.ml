module Make (Donor : TISSUE.T) = struct

    type t = {   donor : Donor.t;
               printer : (module TISSUE_PRINTER.T)
	     }

    let width o = Donor.width o.donor
    let height o = Donor.height o.donor
    let get i o = Donor.get i o.donor

    let print i current o =
      let module P = (val o.printer : TISSUE_PRINTER.T) in
      let p = P.zero in
      let p = P.set_index i p in
      let previous = get i o in
      let open Item in
      match previous, current with

      | _, Empty ->
         p |> P.set_color_for_line
           |> P.draw_hexagon
           |> ignore

      | _, Cytoplasm c ->
         p |> P.set_hels_pigment_as_color c
           |> P.fill_hexagon
           |> P.set_color_for_line
           |> P.draw_hexagon
           |> P.draw_eyes Eyes.Cytoplasm
           |> ignore

      | ActiveCell _, Cell c ->
         p |> P.set_color_for_line
           |> P.draw_nucleus
           |> P.draw_eyes (Eyes.of_cell c)
           |> ignore

      | ActiveCell c, ActiveCell c'
	   when (Protocell.kind_of c) == CellKind.Cancer ->
         p |> P.set_color_for_line
           |> P.draw_eyes (Eyes.Cancer c.gaze)
           |> P.set_color_for_virus
           |> P.draw_eyes (Eyes.Cancer c'.gaze)
           |> ignore

      | ActiveCell c, ActiveCell c' ->
         p |> P.set_pigment_as_color c'.pigment
           |> P.fill_eyes c.gaze
           |> P.set_opposited_pigment_as_color c'.pigment
           |> P.fill_eyes c'.gaze
           |> P.set_color_for_virus
           |> P.draw_eyes (Eyes.Hels c'.gaze)
           |> ignore

      | Cell _, ActiveCell c  ->
         p |> P.set_color_for_clot
           |> P.fill_hexagon
           |> P.set_color_for_line
           |> P.draw_hexagon
           |> P.draw_eyes (Eyes.Clot c.gaze)
           |> ignore

      | Empty,       ActiveCell c
      | Cytoplasm _, ActiveCell c
	   when (Protocell.kind_of c) == CellKind.Cancer ->
         p |> P.set_color_for_cancer
           |> P.fill_nucleus
           |> P.set_color_for_virus
           |> P.draw_nucleus
           |> P.draw_eyes (Eyes.Cancer c.gaze)
           |> ignore

      | Empty,       ActiveCell c
      | Cytoplasm _, ActiveCell c ->
         p |> P.set_pigment_as_color c.pigment
           |> P.fill_nucleus
           |> P.set_opposited_pigment_as_color c.pigment
           |> P.fill_eyes c.gaze
           |> P.set_color_for_virus
           |> P.draw_nucleus
           |> P.draw_eyes (Eyes.Hels c.gaze)
           |> ignore

    let load path =
      let tissue = Donor.load path in

      let max_side_1 =
        (float Window.Tissue.width) /.
          ((float (Donor.width tissue)) *. 1.5 +. 0.5)
      in

      let max_side_2 =
        (float Window.Tissue.height) /.
          ((float (Donor.width tissue)) *. 2.0 +. 1.0) /.
            Const.sqrt_3_div_2
      in

      let max_side = min max_side_1 max_side_2 in
      let module Scale =
	TissueScale.Make (struct
			     let hexagon_side = max_side
			   end)
      in

      let w = Scale.Hexagon.external_radius *.
		(((float (Donor.width tissue)) *. 1.5 +. 0.5))
      in

      let h = Scale.Hexagon.internal_radius *.
		(((float (Donor.width tissue)) *. 2.0 +. 1.0))
      in

      let w = int_of_float (ceil w) in
      let h = int_of_float (ceil h) in
      let dx = (Window.Tissue.width - w) / 2 in
      let dy = (Window.Tissue.height - h) / 2 in
      let module Canvas = Canvas.Shift
			    (Canvas.Resize
			       (Window.Tissue)
			       (struct
				   let width  = w
				   let height = h
				 end))
			    (struct
				let dx = dx
				let dy = dy
			      end)
      in

      let module P = TissuePrinter.Make (Canvas) (Scale)
                              (DefaultColorSheme.Tissue)
      in

      let o = {   donor = tissue;
                printer = (module P : TISSUE_PRINTER.T)
              }
      in

      let _ = for x = 0 to width o do
		for y = 0 to height o do
		  print (x, y) (get (x, y) o) o
		done
	      done
      in
      o

    let set i item o =
      let () = print i item o in
      Donor.set i item o.donor

  end
