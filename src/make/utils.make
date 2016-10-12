echo "Utils build started"

cd ../utils

ocamlopt -for-pack Utils -c vector.mli
ocamlopt -for-pack Utils -c vector.ml
ocamlopt -for-pack Utils -c intPointMap.mli
ocamlopt -for-pack Utils -c intPointMap.ml
ocamlopt -for-pack Utils -c intMap.mli
ocamlopt -for-pack Utils -c intMap.ml
ocamlopt -for-pack Utils -c matrix.mli
ocamlopt -for-pack Utils -c matrix.ml
ocamlopt -for-pack Utils -c MAP_EXT.ml
ocamlopt -for-pack Utils -c mapExt.mli
ocamlopt -for-pack Utils -c mapExt.ml

ocamlopt -pack -o utils.cmx \
vector.cmx intPointMap.cmx intMap.cmx matrix.cmx MAP_EXT.cmx \
mapExt.cmx

mv utils.cmx ../../bin/utils.cmx
mv utils.cmi ../../bin/utils.cmi
mv utils.o ../../bin/utils.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Utils build completed"
