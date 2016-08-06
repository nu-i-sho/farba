type t = { compiler : CompilerConfig.t; 
               base : Out.t
         }

let start file_name config compiler =
  { base = Out.start file_name config;
    compiler 
  }

let output_move_bin_file dir base ext =
  base |> Out.put_all [ "mv *."; ext; " ";
                        dir; Const.end_line
                      ]
  
let put_move_all_bin_files_to dir o =
  { o with base = List.fold_left
                    (output_move_bin_file dir)
                    o.base
                    CompilerConfig.(o.compiler.bin_exts)
  }

let put_none o =
  { o with base = Out.put_none o.base } 
  
let put str o =
  { o with base = Out.put str o.base }

let put_all strs o =
  { o with base = Out.put_all strs o.base }

let put_change_dir_to dir o =
  { o with base = Out.put_change_dir_to dir o.base }

let put_remove dir o =
  { o with base = Out.put_remove dir o.base }

let put_make dir o =
   { o with base = Out.put_make dir o.base }
    
let finish o =
  Out.finish o.base
