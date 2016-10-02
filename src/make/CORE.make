echo "CORE build started"

cd ../CORE

ocamlopt -I ../../bin -for-pack CORE -c TISSUE.ml

ocamlopt -pack -o CORE.cmx \
TISSUE.cmx

mv CORE.cmx ../../bin/CORE.cmx
mv CORE.cmi ../../bin/CORE.cmi
mv CORE.o ../../bin/CORE.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "CORE build completed"

