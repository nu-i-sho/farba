echo "LEVEL build started"

cd ../LEVEL


ocamlopt -I ../../bin -for-pack LEVEL -c SOURCE.ml
ocamlopt -I ../../bin -for-pack LEVEL -c SOURCE_TREE.ml
ocamlopt -pack -o LEVEL.cmx \
SOURCE.cmx SOURCE_TREE.cmx

mv LEVEL.cmx ../../bin/LEVEL.cmx
mv LEVEL.cmi ../../bin/LEVEL.cmi
mv LEVEL.o ../../bin/LEVEL.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "LEVEL build completed"
