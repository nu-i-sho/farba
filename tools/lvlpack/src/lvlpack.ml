(*
     Cannot ganerate valid make file for ocamlopt becouse 
     ocamlopt doesn't support packing case when target and
     packed modules names are the same. 
     For example, run the following code  

         ocamlopt -for-pack X -c X.ml
         mkdir tmp
         mv X.cmi tmp/X.cmi
         mv X.cmx tmp/X.cmx
         mv X.o tmp/X.o
         ocamlopt pack X -o X.cmx tmp/X.cmx 

      and ocamlopt will get
        
         Fatal error: Stack overflow exception

      Code for ocamlopt make file generation are present, 
      maybe described problem will be fixed in one of next 
      versions of OCaml. Please use lvlgen if you want to
      use ocamlopt. 
*)

type compiler = { make_file : string;
                       name : string;
                   bin_exts : string list;
                   main_ext : string;
                    bin_dir : string
		}

let ocamlopt = { make_file = "lvl.make";
                      name = "ocamlopt";
                  bin_exts = [ "cmx"; "cmi"; "o" ];
                  main_ext = "cmx";
                   bin_dir = "bin"
	       }

let ocamlc = { make_file = "lvl_dbg.make";
                    name = "ocamlc";
                bin_exts = [ "cmo"; "cmi" ];
                main_ext = "cmo";
                 bin_dir = "dbg"
	      }

type config = {   farba_dir : string;
                  dummy_src : string list;
                root_module : string;
                 levels_dir : string;
	           make_dir : string;
                    bin_dir : string;
                    src_dir : string;
                       deep : int
	      }

let make_config farba_dir dummy_src deep =

  let src_channel = open_in (farba_dir 
                  ^ "/tools/lvlpack/src/templates/" 
                  ^ dummy_src) in

  let rec load_dummy_src () =  
    try let line = input_line src_channel in
	line :: (load_dummy_src ())
    with End_of_file -> 
      let () = close_in src_channel in 
      []
  in

  {   farba_dir;
      dummy_src = load_dummy_src ();
    root_module = "LevelsSourceTree";
     levels_dir = "levels";
       make_dir = "make";
        src_dir = "src";
        bin_dir = "bin";
           deep
  }

let dots = function | 1 -> "O"
	            | 2 -> "OO"
		    | 3 -> "OOO"
                    | 4 -> "OOOO"
                    | 5 -> "OOOOO"
		    | 6 -> "OOOOOO"
		    | _ -> failwith "out of range"
let all_dots = 
  [ "O"; "OO"; "OOO"; "OOOO"; "OOOOO"; "OOOOOO" ]

let end_line = "\n"
let separator = "\n\n"
let tmp_dir = "t"
let dir_up = "../"
let ml_ext = "ml"

let file name ext =
  name ^ "." ^ ext
 
let out = output_string

let mkdir dir = 

  let parent_dir = Unix.getcwd () in 
  let () = Unix.chdir dir_up
  and parent = Unix.opendir parent_dir in
  
  let rec exists () =
    try if (Unix.readdir parent) = dir then 
	  true else
	  exists () 
    with End_of_file -> 
      false
  in

  let exists = exists () 
  and () = Unix.chdir parent_dir
  and () = Unix.closedir parent
  and () = ignore (Unix.umask 0o000) in

  if exists then 
    Unix.chmod dir 0o777 else 
    Unix.mkdir dir 0o777

let generate_tree config =
  let outline file str =
    [ str; end_line ] |> List.iter (out file) in 
  
  let rec generate_tree i =
    if i = 0 then
      for j = 1 to 6 do
	let lvl = open_out (file (dots j) ml_ext) in
	let () = List.iter (outline lvl) config.dummy_src
	and () = close_out lvl
	 in () 
      done else
      for j = 1 to 6 do
	let lvl = dots j in
	let () = mkdir lvl
	and () = Unix.chdir lvl 
	and () = generate_tree (i - 1)
	and () = Unix.chdir dir_up
         in ()
      done
  in

  generate_tree (config.deep - 1)

let generate_make_file config compiler =
  let make_file = open_out compiler.make_file in

  let open Printf in
  let out = out make_file in
  let out_all = List.iter out in

  let rec module_for =
    function | h :: t -> (module_for t) ^ "." ^ (dots h)
             | []     -> config.root_module in

  let out_compile path i =
    out_all [ compiler.name; " -for-pack "; module_for path;
	      " -c "; file (dots i) ml_ext;
	      end_line
	    ]
      
  and out_move_all_bin_files_to dir =
    let out_move_bin ext =
      out_all [ "mv *."; ext; " "; dir; end_line ] in
    List.iter out_move_bin compiler.bin_exts

  and out_remove dir =
    out_all [ "rm -R "; dir; separator ]

  and out_pack path i = 
    let () = out compiler.name 
    and () = match path with 
             | [] -> ()	     
             | x  -> out_all [ " -for-pack "; module_for x ]
	       
    and () = out " -pack -o "
    and () = out (file (match path with
			| [] -> config.root_module 
			| _  -> (dots i)) 
		       compiler.main_ext)

    and file_for_pack name  = 
      [ " "; tmp_dir; "/"; file name compiler.main_ext ] in
    let () = all_dots |> List.map file_for_pack
                      |> List.iter out_all
    and () = out separator
     in ()

  and out_change_dir_to dir =
    out_all [ "cd "; dir; end_line ] in 

  let rec generate down up =
    let pack up branch = 
      let () = out end_line
      and () = out_all [ "mkdir "; tmp_dir; separator ]
      and () = out_move_all_bin_files_to tmp_dir
      and () = out end_line
      and () = out_pack up branch
      and () = out_remove tmp_dir
       in () in

    match down, up with

    | down, (7 :: branch :: up)
      -> let () = pack up branch
	 and () = out_move_all_bin_files_to dir_up
	 and () = out end_line
	 and () = out_change_dir_to dir_up in
	 generate (down + 1) ((branch + 1) :: up)

    | 0, (1 :: up) 
      -> let () = out end_line
         and () = out_compile up 1 in
	 generate 0 (2 :: up) 
         
    | 0, (leaf :: up) 
      -> let () = out_compile up leaf in
	 generate 0 ((leaf + 1) :: up) 

    | _, [7]
      -> let bin_dir = dir_up ^ dir_up ^ config.bin_dir in
	 out_move_all_bin_files_to bin_dir

    | down, (branch :: up)
      -> let () = out_change_dir_to (dots branch) in
	 generate (down - 1) (1 :: branch :: up)

    | _ -> failwith "impossible case"
  in 

  let rec make_path i = 
    if i <> 0 then 
      1 :: (make_path (i - 1)) else
      [] 
  in
  
  let () = out_change_dir_to dir_up
  and () = out_change_dir_to config.levels_dir
  and () = for i = 0 to config.deep - 2 do
	     out_change_dir_to (dots 1)
	   done
  and () = generate 0 (make_path config.deep)
  and () = close_out make_file
   in ()

let generate farba_dir dummy_src deep = 
  let config = make_config farba_dir dummy_src deep
  and return = Unix.getcwd () in

  let () = Unix.chdir config.farba_dir
  and () = Unix.chdir config.src_dir
  and () = mkdir config.levels_dir
  and () = Unix.chdir config.levels_dir
  and () = generate_tree config
 
  and () = Unix.chdir dir_up
  and () = Unix.chdir config.make_dir
  and () = generate_make_file config ocamlc
(*and () = generate_make_file config ocamlopt*)
  and () = Unix.chdir return
   in ()
