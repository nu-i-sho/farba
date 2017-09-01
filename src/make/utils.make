echo "Utils build started"

cd ../utils

ocamlopt -for-pack Utils -c dots.mli
ocamlopt -for-pack Utils -c dots.ml
ocamlopt -for-pack Utils -c MAPEXT.ml
ocamlopt -for-pack Utils -c mapExt.mli
ocamlopt -for-pack Utils -c mapExt.ml
ocamlopt -for-pack Utils -c intMap.mli
ocamlopt -for-pack Utils -c intMap.ml
ocamlopt -for-pack Utils -c listExt.mli
ocamlopt -for-pack Utils -c listExt.ml
ocamlopt -for-pack Utils -c listOne.mli
ocamlopt -for-pack Utils -c -w -8 listOne.ml

ocamlopt -pack -o utils.cmx \
dots.cmx MAPEXT.cmx mapExt.cmx intMap.cmx listExt.cmx listOne.cmx

mv utils.cmx ../../bin/utils.cmx
mv utils.cmi ../../bin/utils.cmi
mv utils.o ../../bin/utils.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Utils build completed"
