echo "Core build started"

cd ../core

ocamlopt -for-pack Core -c side.mli
ocamlopt -for-pack Core -c side.ml

ocamlopt -pack -o core.cmx \
side.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Utils build completed"
