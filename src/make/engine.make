echo "------ Engine build started ------"

cd ../engine

ocamlopt -I ../../bin -for-pack Engine -c programPoint.ml

ocamlopt -pack -o engine.cmx \
programPoint.cmx

mv engine.cmx ../../bin/engine.cmx
mv engine.cmi ../../bin/engine.cmi
mv engine.o ../../bin/engine.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "----- Engine build completed -----"

