type t = {      kind : Compiler.t;
           make_file : string;
                name : string;
            bin_exts : string list;
            main_ext : string;
             bin_dir : string
	 }

let ocamlopt = {      kind = Compiler.Ocamlopt;
                 make_file = "lvl.make";
                      name = "ocamlopt";
                  bin_exts = [ "cmx"; "cmi"; "o" ];
                  main_ext = "cmx";
                   bin_dir = "bin"
	       }

let ocamlc = {      kind = Compiler.Ocamlc;
               make_file = "lvl_dbg.make";
                    name = "ocamlc";
                bin_exts = [ "cmo"; "cmi" ];
                main_ext = "cmo";
                 bin_dir = "dbg"
	     }

let of_compiler =
  function | Compiler.Ocamlopt -> ocamlopt
           | Compiler.Ocamlc   -> ocamlc
