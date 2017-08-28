echo "Utils build started"

cd ../utils

ocamlopt -for-pack Utils -c dots.mli
ocamlopt -for-pack Utils -c dots.ml
ocamlopt -for-pack Utils -c MAPEXT.ml
ocamlopt -for-pack Utils -c mapExt.mli
ocamlopt -for-pack Utils -c mapExt.ml

ocamlopt -pack -o utils.cmx \
dots.cmx MAPEXT.cmx mapExt.cmx

mv utils.cmx ../../bin/utils.cmx
mv utils.cmi ../../bin/utils.cmi
mv utils.o ../../bin/utils.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Utils build completed"
