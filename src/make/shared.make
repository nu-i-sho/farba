echo "Shared build started"

cd ../shared

ocamlopt -I ../../bin -for-pack Shared -c pigment.mli
ocamlopt -I ../../bin -for-pack Shared -c pigment.ml
ocamlopt -I ../../bin -for-pack Shared -c dots.mli
ocamlopt -I ../../bin -for-pack Shared -c dots.ml
ocamlopt -I ../../bin -for-pack Shared -c nucleus.mli
ocamlopt -I ../../bin -for-pack Shared -c nucleus.ml
ocamlopt -I ../../bin -for-pack Shared -c cell.mli
ocamlopt -I ../../bin -for-pack Shared -c cell.ml
ocamlopt -for-pack Shared -c fail.ml
ocamlopt -I ../../bin -for-pack Shared -c dotsNodeMap.mli
ocamlopt -I ../../bin -for-pack Shared -c dotsNodeMap.ml
ocamlopt -I ../../bin -for-pack Shared -c coord.mli
ocamlopt -I ../../bin -for-pack Shared -c coord.ml

ocamlopt -pack -o shared.cmx \
pigment.cmx dots.cmx nucleus.cmx cell.cmx fail.cmx dotsNodeMap.cmx \
coord.cmx

mv shared.cmx ../../bin/shared.cmx
mv shared.cmi ../../bin/shared.cmi
mv shared.o ../../bin/shared.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Shared build completed"
