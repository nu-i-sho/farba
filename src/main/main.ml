
open Shared

(*
struct
  let width  = program_width
  let height = height - 2 * d
end
 *)

(*let () = try begin*)
let () = begin
    let () = Graphics.open_graph " 800x500" in
    let width = 800 in (*Graphics.size_x () in*)
    let height = 500 in (*Graphics.size_y () in*)
    let d = (width + height) / 30 in
    let program_width = 216 (* 54 x 54 *) in
    let tissue_width = width - program_width - 3 * d in

    let module TissueCanvas = 
      View.Canvas.Shift (View.Canvas)
			(struct
			    let dx = 
			      let () = print_string " DX:" in
                              let () = print_int (d / 2) in
			      d
			    let dy = d
			  end)
    in				   
    let module ProgramCanvas = 
      View.Canvas.Shift (View.Canvas)
			(struct
			    let dx = 2 * d + tissue_width
			    let dy = d
			  end)
    in
    let module Tissue = 
      View.Tissue.Make (TissueCanvas) 
		       (Core.Tissue)
	in
    let module TissueCell =
      Core.TissueCell.Make (Tissue)
    in
    let module ProgramPrinter = 
      View.ProgramPrinter.Make (ProgramCanvas)
			       (View.Img.Command.Default)
                               (View.ProgramPointer)
    in    
    let module Breadcrumbs = 
      View.Breadcrumbs.Make (Core.Breadcrumbs)
			    (ProgramCanvas)
			    (View.ProgramPointer)
			    (View.Img.Breadcrumbs.Default)
    in
    let module Virus = 
      Core.Virus.Make (Breadcrumbs)
		      (TissueCell) 
    in

    let colony = Colony.load [ "00";
			       "00";
			     ]
    in
    let () = print_string "<-1>" in
    let tissue = Core.Tissue.make colony in
    let () = print_string "<0>" in
    let tissue = Tissue.make ~donor:tissue
                             ~width:tissue_width
			    ~height:(height - 2 * d)
    in
    let () = print_string "<1>" in
    let Some cell = TissueCell.make tissue (0, 0) in
    let () = print_string "<2>" in
    let program = Program.load "675473044202F200C26D55E1" in
    let () = print_string "<3>" in
    let pointer = View.ProgramPointer.make 
		    (Program.length program) in
    let () = print_string "<4>" in
    let () = ProgramPrinter.print program pointer in
    let () = print_string "<5>" in
    let breadcrumbs = Breadcrumbs.make ~pointer
		       ~breadcrumbs:Core.Breadcrumbs.start 
    in
    let () = print_string "<6>" in
    let virus = Virus.make ~program 
                          ~infected:cell 
                       ~breadcrumbs
    in
    let () = print_string "<7>" in
    let rec main o frame_time =
      match o with
      | Some o -> 
	 let () = print_string "*" in
	 let rec delay () =
	   let duration = frame_time +. 0.225 -. 
			    Unix.gettimeofday () 
	   in
	   if duration > 0.0 then
	     try
               Thread.delay duration
	     with | Unix.Unix_error (Unix.EAGAIN, _, _) 
		  | Unix.Unix_error (Unix.EINTR, _, _) 
		    -> delay ()
	 in
	 let () = delay () in
	 let () = print_string "#" in
	 main (Virus.next o) (Unix.gettimeofday  ())
      | None -> ()
    in
    main (Some virus) (Unix.gettimeofday  ())
  end
