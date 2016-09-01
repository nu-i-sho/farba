echo "------- CORE build started -------"

cd ../CORE

ocamlopt -I ../../bin -for-pack CORE -c INDEX.ml
ocamlopt -I ../../bin -for-pack CORE -c TISSUE.ml
ocamlopt -I ../../bin -for-pack CORE -c WEAVER.ml

ocamlopt -pack -o CORE.cmx \
INDEX.cmx TISSUE.cmx WEAVER.cmx

mv CORE.cmx ../../bin/CORE.cmx
mv CORE.cmi ../../bin/CORE.cmi
mv CORE.o ../../bin/CORE.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ CORE build completed ------"
