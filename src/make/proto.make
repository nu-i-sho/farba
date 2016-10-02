echo "Proto build started"

cd ../proto

ocamlopt -I ../../bin -for-pack Proto -c pigment.mli
ocamlopt -I ../../bin -for-pack Proto -c pigment.ml
ocamlopt -I ../../bin -for-pack Proto -c dotsOfDice.mli
ocamlopt -I ../../bin -for-pack Proto -c dotsOfDice.ml
ocamlopt -I ../../bin -for-pack Proto -c nucleus.mli
ocamlopt -I ../../bin -for-pack Proto -c nucleus.ml
ocamlopt -I ../../bin -for-pack Proto -c cell.mli
ocamlopt -I ../../bin -for-pack Proto -c cell.ml

ocamlopt -pack -o proto.cmx \
pigment.cmx dotsOfDice.cmx nucleus.cmx cell.cmx

mv proto.cmx ../../bin/proto.cmx
mv proto.cmi ../../bin/proto.cmi
mv proto.o ../../bin/proto.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Proto build completed"
