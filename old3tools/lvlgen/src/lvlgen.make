ocamlopt unix.cmxa -o lvlpack.run const.mli const.ml str.mli str.ml config.mli config.ml compiler.ml compilerConfig.mli compilerConfig.ml OUTPUT.ml out.mli out.ml extOut.mli extOut.ml uniX.mli uniX.ml levelFile.mli levelFile.ml firstPath.mli firstPath.ml dots.mli dots.ml FILES_GENERATOR.ml treeGenerator.mli treeGenerator.ml listGenerator.mli listGenerator.ml generator.mli generator.ml lvlgen.mli lvlgen.ml main.ml

mv lvlpack.run ../bin/lvlgen.run

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete
