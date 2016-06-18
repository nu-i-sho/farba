open Shared

(*let () = try begin*)
let () = begin
    let module Tissue = 
      View.Tissue.Make (View.Window.Tissue) 
		       (Core.Tissue)
    in
    let module TissueCell =
      Core.TissueCell.Make (Tissue)
    in
    let module ProgramPrinter = 
      View.ProgramPrinter.Make (View.Window.Program)
			       (View.Img.Command.Default)
                               (View.ProgramPointer)
    in    
    let module Breadcrumbs = 
      View.Breadcrumbs.Make (Core.Breadcrumbs)
			    (View.Window.Program)
			    (View.ProgramPointer)
			    (View.Img.Breadcrumbs.Default)
    in
    let module Virus = 
      Core.Virus.Make (Breadcrumbs)
		      (TissueCell) 
    in

    let colony = Colony.load [ "10101";
	  		       "11101";
			       "01101";
			       "00101"
                             ]
    in
    let Some cell = TissueCell.first colony (0, 0) in
    let program = Program.load "011021011222212300" in
    let pointer = View.ProgramPointer.make 
		    (Program.length program) in
    let () = ProgramPrinter.print program pointer in
    let breadcrumbs = Breadcrumbs.make ~pointer
		       ~breadcrumbs:Core.Breadcrumbs.start in
    let () = print_string "-7-" in
    let virus = Virus.make ~program 
                          ~infected:cell 
                       ~breadcrumbs
    in
    let () = print_string "-8-" in
    let rec main o frame_time =
      match o with
      | Some o -> 
	 let () = print_string "*" in
	 let rec delay () =
	   let duration = frame_time +. 2.225 -. 
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
