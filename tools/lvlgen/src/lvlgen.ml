module LGenerator = Generator.Make (ListGenerator)
module TGenerator = Generator.Make (TreeGenerator)

let generate_tree farba_dir dummy_src deep = 
  let config = Config.make farba_dir dummy_src deep in
  TGenerator.generate config Compiler.all_compilers

let generate_list farba_dir dummy_src deep =
  let config = Config.make farba_dir dummy_src deep in
  LGenerator.generate config Compiler.all_compilers
