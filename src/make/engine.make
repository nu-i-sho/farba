echo "------ Engine build started ------"

cd ../engine

ocamlopt -I ../../bin -for-pack Engine -c breadcrumbs.mli
ocamlopt -I ../../bin -for-pack Engine -c breadcrumbs.ml
ocamlopt -I ../../bin -for-pack Engine -c programPoint.ml
ocamlopt -I ../../bin -for-pack Engine -c programLine.ml
ocamlopt -for-pack Engine -c PROGRAM.ml
ocamlopt -I ../../bin -for-pack Engine -c program.mli
ocamlopt -I ../../bin -for-pack Engine -c program.ml
ocamlopt -for-pack Engine -c SCROLLABLE_PROGRAM.ml
ocamlopt -I ../../bin -for-pack Engine -c scrollableProgram.mli
ocamlopt -for-pack Engine -c scrollableProgram.ml
ocamlopt -for-pack Engine -c stackableProgramLine.ml
ocamlopt -I ../../bin -for-pack Engine -c stackableProgram.mli
ocamlopt -I ../../bin -for-pack Engine -c stackableProgram.ml

ocamlopt -pack -o engine.cmx \
breadcrumbs.cmx programPoint.cmx programLine.cmx PROGRAM.cmx \
program.cmx SCROLLABLE_PROGRAM.cmx scrollableProgram.cmx \
stackableProgramLine.cmx stackableProgram.cmx

mv engine.cmx ../../bin/engine.cmx
mv engine.cmi ../../bin/engine.cmi
mv engine.o ../../bin/engine.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "----- Engine build completed -----"

