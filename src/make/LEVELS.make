echo "LEVELS build started"

cd ../LEVELS

ocamlopt -I ../../bin -for-pack LEVELS -c SOURCE_TREE.ml
ocamlopt -pack -o LEVELS.cmx SOURCE_TREE.cmx

mv LEVELS.cmx ../../bin/LEVELS.cmx
mv LEVELS.cmi ../../bin/LEVELS.cmi
mv LEVELS.o ../../bin/LEVELS.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "LEVELS build completed"
