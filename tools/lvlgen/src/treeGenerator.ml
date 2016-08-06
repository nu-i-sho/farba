let generate_levels_files config =
  let open Config in
  let rec generate i =
    if i = 0 then
      for j = 1 to 6 do
        LevelFile.create config.dummy_src (Dots.to_string j)
      done else
      for j = 1 to 6 do
	let level = Dots.to_string j in
	let () = UniX.mkdir level
	and () = Unix.chdir level 
	and () = generate (i - 1)
	and () = Unix.chdir Const.dir_up
         in ()
      done
  in generate (config.deep - 1)

let generate_make_file config compiler =
  let module Out = ExtOut in
  let open Config in
  let open CompilerConfig in
  
  let rec module_for =
    function | h :: t -> (module_for t) ^ "." ^ (Dots.to_string h)
             | []     -> config.root_module in

  let output_compile path i out =
    out |> Out.put_all [ compiler.name; " -for-pack ";
                         module_for path;
	                 " -c "; Str.ml_file (Dots.to_string i);
                         Const.end_line
	               ]
  
  and output_pack path i out =
    let output_file_for_pack out name = 
      out |> Out.put_all [ " "; Const.tmp_dir; "/";
                           Str.file name compiler.main_ext
                         ]
    and out =
      out |> Out.put Const.end_line
          |> Out.put_make Const.tmp_dir
          |> Out.put Const.end_line
          |> Out.put_move_all_bin_files_to Const.tmp_dir
          |> Out.put Const.end_line
          |> Out.put compiler.name
      
          |> ( match path with 
               | [] -> Out.put_none	     
               | x  -> Out.put_all [ " -for-pack "; module_for x ] )
          |> Out.put " -pack -o "
          |> Out.put (Str.file ( match path with
                                 | [] -> Str.start_with_lowercase
                                           config.root_module 
			         | _  -> (Dots.to_string i) ) 
		               compiler.main_ext)
    in
    
    Dots.all_strings |> List.fold_left output_file_for_pack out
                     |> Out.put Const.separator
                     |> Out.put_remove Const.tmp_dir
                     |> Out.put Const.end_line
  in
  
  let rec generate down up out = 
    match down, up with

    | down, (7 :: branch :: up)
      -> out |> output_pack up branch
             |> Out.put_move_all_bin_files_to Const.dir_up
             |> Out.put Const.end_line
             |> Out.put_change_dir_to Const.dir_up
             |> generate (down + 1) ((branch + 1) :: up)

    | 0, (1 :: up) 
      -> out |> Out.put Const.end_line
             |> output_compile up 1
             |> generate 0 (2 :: up) 
         
    | 0, (leaf :: up) 
      -> out |> output_compile up leaf
             |> generate 0 ((leaf + 1) :: up) 

    | _, [7]
      -> out |> Out.put_move_all_bin_files_to
                  (Const.dir_up ^ Const.dir_up ^ config.bin_dir)

    | down, (branch :: up)
      -> out |> Out.put_change_dir_to (Dots.to_string branch)
             |> generate (down - 1) (1 :: branch :: up)

    | _
      -> failwith Const.impossible_case
  in 

  let output_change_dir_to_first_leaf out =
    let rec output_change_dir i out = 
      if i = config.deep - 1 then out else
        out |> Out.put_change_dir_to (Dots.to_string 1)
            |> output_change_dir (i + 1)
    in out |> output_change_dir 0
  in
  
  (Out.start compiler.make_file config compiler)
      |> Out.put Const.auto_generated_make_file_header
      |> Out.put Const.end_line
      |> Out.put_change_dir_to Const.dir_up
      |> Out.put_change_dir_to config.levels_dir
      |> output_change_dir_to_first_leaf
      |> generate 0 (FirstPath.make_1 config.deep)
      |> Out.finish
