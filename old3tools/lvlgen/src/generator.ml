module Make (FilesGenerator : FILES_GENERATOR.T) = struct
  
  let generate config compilers =
    let open Config in
    
    let return = Unix.getcwd () in

    let () = Unix.chdir config.farba_dir
    and () = Unix.chdir config.src_dir
    and () = UniX.mkdir config.levels_dir
    and () = Unix.chdir config.levels_dir
    and () = FilesGenerator.generate_levels_files config
           
    and () = Unix.chdir Const.dir_up
    and () = Unix.chdir config.make_dir
    and () =
      compilers
        |> List.map CompilerConfig.of_compiler
        |> List.iter (FilesGenerator.generate_make_file config)
    in

    Unix.chdir return
end
