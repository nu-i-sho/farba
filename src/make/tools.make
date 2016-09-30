echo "------- Tools build started ------"

cd ../tools

ocamlopt -for-pack Tools -c intMap.mli
ocamlopt -for-pack Tools -c intMap.ml
ocamlopt -for-pack Tools -c intPointMap.mli
ocamlopt -for-pack Tools -c intPointMap.ml
ocamlopt -for-pack Tools -c matrix.mli
ocamlopt -for-pack Tools -c matrix.ml
ocamlopt -for-pack Tools -c initable.mli
ocamlopt -I ../../bin -for-pack Tools -c initable.ml
ocamlopt -I ../../bin -for-pack Tools -c dotsOfDiceNodeMap.mli
ocamlopt -I ../../bin -for-pack Tools -c dotsOfDiceNodeMap.ml

ocamlopt -pack -o tools.cmx \
intMap.cmx intPointMap.cmx matrix.cmx dotsOfDiceNodeMap.cmx \
initable.cmx

mv tools.cmx ../../bin/tools.cmx
mv tools.cmi ../../bin/tools.cmi
mv tools.o ../../bin/tools.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Tools build completed -----"
