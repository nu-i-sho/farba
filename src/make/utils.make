echo "Utils build started"

cd ../utils

ocamlopt -for-pack Utils -c SEQUENTIAL.ml
ocamlopt -for-pack Utils -c pair.mli
ocamlopt -for-pack Utils -c pair.ml
ocamlopt -for-pack Utils -c MAPEXT.ml
ocamlopt -for-pack Utils -c mapExt.mli
ocamlopt -for-pack Utils -c mapExt.ml
ocamlopt -for-pack Utils -c listOne.mli
ocamlopt -for-pack Utils -c -w -8 listOne.ml

ocamlopt -pack -o utils.cmx \
SEQUENTIAL.cmx pair.cmx MAPEXT.cmx mapExt.cmx listOne.cmx

mv utils.cmx ../../bin/utils.cmx
mv utils.cmi ../../bin/utils.cmi
mv utils.o ../../bin/utils.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Utils build completed"
