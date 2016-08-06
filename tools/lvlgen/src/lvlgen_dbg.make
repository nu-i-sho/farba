ocamlc unix.cma -o lvlpack_dbg.run const.mli const.ml str.mli str.ml config.mli config.ml compiler.ml compilerConfig.mli compilerConfig.ml OUTPUT.ml out.mli out.ml extOut.mli extOut.ml uniX.mli uniX.ml levelFile.mli levelFile.ml firstPath.mli firstPath.ml dots.mli dots.ml FILES_GENERATOR.ml treeGenerator.mli treeGenerator.ml listGenerator.mli listGenerator.ml generator.mli generator.ml lvlgen.mli lvlgen.ml main.ml

mv lvlpack_dbg.run ../bin/lvlgen_dbg.run

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete
