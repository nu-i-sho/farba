type t = private {   farba_dir : string;
                     dummy_src : string list;
                   root_module : string;
                    levels_dir : string;
	              make_dir : string;
                       bin_dir : string;
                       src_dir : string;
                          deep : int
	         }

val make : string -> string -> int -> t
