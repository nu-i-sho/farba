echo "------ Engine build started ------"

cd ../engine

ocamlopt -I ../../bin -for-pack Engine -c breadcrumbs.mli
ocamlopt -I ../../bin -for-pack Engine -c breadcrumbs.ml
ocamlopt -I ../../bin -for-pack Engine -c programPoint.ml
ocamlopt -I ../../bin -for-pack Engine -c programLine.ml
ocamlopt -for-pack Engine -c PROGRAM.ml
ocamlopt -I ../../bin -for-pack Engine -c program.mli
ocamlopt -I ../../bin -for-pack Engine -c program.ml

ocamlopt -pack -o engine.cmx \
breadcrumbs.cmx programPoint.cmx programLine.cmx PROGRAM.cmx \
program.cmx

mv engine.cmx ../../bin/engine.cmx
mv engine.cmi ../../bin/engine.cmi
mv engine.o ../../bin/engine.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "----- Engine build completed -----"

