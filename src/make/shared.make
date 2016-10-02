echo "Shared build started"

cd ../shared

ocamlopt -I ../../bin -for-pack Shared -c pigment.mli
ocamlopt -I ../../bin -for-pack Shared -c pigment.ml
ocamlopt -I ../../bin -for-pack Shared -c dotsOfDice.mli
ocamlopt -I ../../bin -for-pack Shared -c dotsOfDice.ml
ocamlopt -I ../../bin -for-pack Shared -c nucleus.mli
ocamlopt -I ../../bin -for-pack Shared -c nucleus.ml
ocamlopt -I ../../bin -for-pack Shared -c cell.mli
ocamlopt -I ../../bin -for-pack Shared -c cell.ml

ocamlopt -pack -o shared.cmx \
pigment.cmx dotsOfDice.cmx nucleus.cmx cell.cmx

mv shared.cmx ../../bin/shared.cmx
mv shared.cmi ../../bin/shared.cmi
mv shared.o ../../bin/shared.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Shared build completed"
