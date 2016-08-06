echo "------- Core build started -------"

cd ../core

ocamlopt -for-pack Core -c MODULE.ml
ocamlopt -I ../../bin -for-pack Core -c dotsOfDice.mli
ocamlopt -I ../../bin -for-pack Core -c dotsOfDice.ml 

ocamlopt -pack -o core.cmx MODULE.cmx dotsOfDice.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Core build completed ------"
