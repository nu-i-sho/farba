type t = private {      kind : Compiler.t;
                   make_file : string;
                        name : string;
                    bin_exts : string list;
                    main_ext : string;
                     bin_dir : string
	         }

val ocamlopt : t
val ocamlc : t
val of_compiler : Compiler.t -> t
