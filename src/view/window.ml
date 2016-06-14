let () = Graphics.open_graph ""
let width = Graphics.size_x ()
let height = Graphics.size_y ()
let d = (width + height) / 40
let program_width = 216 (* 54 x 54 *)
let tissue_width = width - program_width - 3 * d


module Tissue =
  Canvas.Shift (Canvas.Make(struct 
			      let width  = tissue_width
			      let height = height - 2 * d
			    end))
	       (struct
		   let dx = d
		   let dy = d
		 end)

module Program = 
  Canvas.Shift (Canvas.Make(struct
			       let width  = program_width
			       let height = height - 2 * d
			     end))
	       (struct
		   let dx = 2 * d + tissue_width
		   let dy = d
		 end)

