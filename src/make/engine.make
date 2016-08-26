echo "------ Engine build started ------"

cd ../engine

ocamlopt -I ../../bin -for-pack Engine -c breadcrumbs.mli
ocamlopt -I ../../bin -for-pack Engine -c breadcrumbs.ml

ocamlopt -pack -o engine.cmx \
breadcrumbs.cmx

mv engine.cmx ../../bin/engine.cmx
mv engine.cmi ../../bin/engine.cmi
mv engine.o ../../bin/engine.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "----- Engine build completed -----"

