echo "SHARED build started"

cd ../SHARED

ocamlopt -for-pack SHARED -c MODULE.ml
ocamlopt -for-pack SHARED -c DOTS_NODE.ml

ocamlopt -pack -o SHARED.cmx \
MODULE.cmx DOTS_NODE.cmx

mv SHARED.cmx ../../bin/SHARED.cmx
mv SHARED.cmi ../../bin/SHARED.cmi
mv SHARED.o ../../bin/SHARED.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "SHARED build completed"
