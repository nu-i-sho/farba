let print_line src =
  print_string (src ^ Const.end_line)
  
let run () =
  if (Array.length Sys.argv) <> 2 then
    print_line Const.args_help else

    let () = Unix.chdir Const.dir_up
    and () = Unix.chdir Const.dir_up
    and () = Unix.chdir Const.dir_up
    and farba_dir = Unix.getcwd ()
    and () = Unix.chdir "tools/lvlgen/bin/"
    and output_warning () =
      let () = print_line Const.warning
      and () = print_line Const.separation_line
      and () = List.iter print_line Const.tree_generator_warning
      and () = print_line Const.separation_line
      in ()
    in
    
    match Sys.argv.(1) with
      
    | "-tree" -> let () = output_warning ()
                 and () = print_line Const.started
                 and () = Lvlgen.generate_tree farba_dir "1" 3
                 and () = print_line Const.succesfully_generated
                  in ()
                  
    | "-list" -> let () = print_line Const.started
                 and () = Lvlgen.generate_list farba_dir "1" 3
                 and () = print_line Const.succesfully_generated
                  in ()
                  
    | _       -> print_line Const.args_help
     
let () = run ()
