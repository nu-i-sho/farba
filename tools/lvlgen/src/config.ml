type t = {   farba_dir : string;
             dummy_src : string list;
           root_module : string;
            levels_dir : string;
	      make_dir : string;
               bin_dir : string;
               src_dir : string;
                  deep : int
	 }

let make farba_dir dummy_src deep =
  let src_channel = open_in (farba_dir 
                  ^ "/tools/lvlgen/src/templates/" 
                  ^ (Str.ml_file dummy_src)) in

  let rec load_dummy_src () =  
    try let line = input_line src_channel in
	line :: load_dummy_src () 
    with End_of_file -> 
      let () = close_in src_channel in 
      []
  in
  
  let dummy_src =
    Const.auto_genereted_ml_file_header
    :: (load_dummy_src ()) in
  
  {   farba_dir;
      dummy_src;
    root_module = "LevelsSourceTree";
     levels_dir = "levels";
       make_dir = "make";
        src_dir = "src";
        bin_dir = "bin";
           deep
  }
