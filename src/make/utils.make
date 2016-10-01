echo "|----- Utils build started -----|"

cd ../utils

ocamlopt -for-pack Utils -c vector.mli
ocamlopt -for-pack Utils -c vector.ml

ocamlopt -pack -o utils.cmx \
vector.cmx

mv utils.cmx ../../bin/utils.cmx
mv utils.cmi ../../bin/utils.cmi
mv utils.o ../../bin/utils.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "|---- Utils build completed ----|"
