let files_names deep =
  let rec name_of path =
    match path with
    | [h]    -> Dots.to_string h
    | h :: t -> (name_of t) ^ "_" ^ (Dots.to_string h)  
    | []     -> failwith Const.impossible_case in

  let rec files_names down up acc = 
    match down, up with

    | down, (0 :: branch :: up)
        -> files_names (down + 1) ((branch - 1) :: up) acc
         
    | 0, ((leaf :: up) as path)
        -> files_names 0 ((leaf - 1) :: up) ((name_of path) :: acc)

    | _, [0]
        -> acc
                
    | down, (branch :: up)
        -> files_names (down - 1) (6 :: branch :: up) acc
       
    | _ -> failwith Const.impossible_case
  in files_names 0 (FirstPath.make_6 deep) []
                
let root_module_ml_file name =
  name |> Str.start_with_lowercase
       |> Str.ml_file
   
let generate_root_module_file config =
  let open Config in
  
  let rec shift =
    function | 0 -> ""
             | i -> "  " ^ (shift (i - 1)) in
  
  let rec generate down up modules out =
    let shift i = shift (config.deep - 1 - i) in
    match down, up with
      
    | down, (7 :: branch :: up)
      -> let down = down + 1 in
         out |> Out.put_all [ shift down; "end"; Const.separator; ]
             |> generate down ((branch + 1) :: up) modules

    | 0, (leaf :: up)
      -> let text = [ shift 0; "module "; Dots.to_string leaf;
                      " = "; List.hd modules; Const.end_line
                    ] in
         out |> Out.put_all text 
             |> generate 0 ((leaf + 1) :: up) (List.tl modules)
    | _, [7]
      -> out

    | down, []
      -> out |> generate (down - 1) [1] modules

    | down, (branch :: up)
      -> let text = [ shift down; "module "; Dots.to_string branch;
                      " = struct"; Const.end_line
                    ] in
         out |> Out.put_all text 
             |> generate (down - 1) (1 :: branch :: up) modules
  in

  let modules = files_names config.deep in
  (Out.start (root_module_ml_file config.root_module) config) 
     |> Out.put Const.auto_genereted_ml_file_header
     |> generate config.deep [] modules
     |> Out.finish

let generate_levels_files config =
  let open Config in
  let () = generate_root_module_file config
  and create = LevelFile.create config.dummy_src in
  config.deep |> files_names
              |> List.iter create

let generate_make_file config compiler = 
  let module Out = ExtOut in
  let open CompilerConfig in
  let open Config in
  
  let bin_dir = Const.dir_up ^ Const.dir_up ^ config.bin_dir in
  let levels_bin_dir = bin_dir ^ "/" ^ config.levels_dir in
  
  let ml_files = config.deep |> files_names 
                             |> List.map Str.ml_file
  and output_compile out file =
    out |> Out.put_all [ compiler.name; " -c ";
                         file; Const.end_line
                       ]
  and output_levels_bin_dir =
    Out.put_all [ Const.end_line; compiler.name;
                  " -I "; levels_bin_dir; " "
                ] in
  
  ml_files |> List.map Str.ml_file
           |> List.fold_left
                output_compile
                ((Out.start compiler.make_file config compiler)
                    |> Out.put Const.auto_generated_make_file_header
                    |> Out.put Const.end_line
                    |> Out.put_change_dir_to Const.dir_up
                    |> Out.put_change_dir_to config.levels_dir
                    |> Out.put Const.end_line)

           |> Out.put Const.end_line
           |> Out.put_remove levels_bin_dir
           |> Out.put_make levels_bin_dir
           |> Out.put Const.end_line
           |> Out.put_move_all_bin_files_to levels_bin_dir 
           |> output_levels_bin_dir
           |> Out.put (root_module_ml_file config.root_module)
           |> Out.put Const.separator
           |> Out.put_move_all_bin_files_to bin_dir
           |> Out.finish
