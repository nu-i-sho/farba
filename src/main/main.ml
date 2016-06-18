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

    let () = print_string "-1-" in
    let colony = Colony.load [ "10101";
	  		       "11101";
			       "01101";
			       "00101"
                             ]
    in
    let () = print_string "-2-" in
    let Some cell = TissueCell.first colony (0, 0) in
    let () = print_string "-3-" in
    let program = Program.load "AB123ABAFE16572220" in
    let () = print_string "-4-" in
    let pointer = View.ProgramPointer.make 
		    (Program.length program) in
    let () = print_string "-5-" in
    let () = ProgramPrinter.print program pointer in
    let () = print_string "-6-" in
    let breadcrumbs = Breadcrumbs.make ~pointer
		       ~breadcrumbs:Core.Breadcrumbs.start in
    let () = print_string "-7-" in
    let virus = Virus.make ~program 
                          ~infected:cell 
                       ~breadcrumbs
    in
    let rec run o = 
      let () = Unix.sleep 1 in
      match Virus.next o with
      | Some o -> run o
      | None -> ()
    in
    let () = Graphics.open_graph "" in
    run virus
  end 
(*with e -> 
  let trace = Printexc.get_raw_backtrace () in
  Printexc.print_raw_backtrace stdout trace
 *)
