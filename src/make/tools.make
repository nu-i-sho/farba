echo "------- Tools build started ------"

cd ../tools

ocamlopt -I ../../bin -for-pack Tools -c dotsOfDiceNodeMap.mli
ocamlopt -I ../../bin -for-pack Tools -c dotsOfDiceNodeMap.ml

ocamlopt -pack -o tools.cmx dotsOfDiceNodeMap.cmx

mv tools.cmx ../../bin/tools.cmx
mv tools.cmi ../../bin/tools.cmi
mv tools.o ../../bin/tools.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Tools build completed -----"
