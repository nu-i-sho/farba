echo "Core build started"

cd ../core

ocamlopt -for-pack Core -c map.mli
ocamlopt -for-pack Core -c map.ml
ocamlopt -for-pack Core -c dots.mli
ocamlopt -for-pack Core -c dots.ml
ocamlopt -for-pack Core -c hand.ml
ocamlopt -for-pack Core -c gene.ml
ocamlopt -for-pack Core -c nature.ml
ocamlopt -for-pack Core -c pigment.mli
ocamlopt -for-pack Core -c pigment.ml
ocamlopt -for-pack Core -c side.mli
ocamlopt -for-pack Core -c side.ml
ocamlopt -for-pack Core -c nucleus.mli
ocamlopt -for-pack Core -c nucleus.ml
ocamlopt -for-pack Core -c action.ml
ocamlopt -for-pack Core -c tissue.mli
ocamlopt -for-pack Core -c tissue.ml
ocamlopt -for-pack Core -c cursor.mli
ocamlopt -for-pack Core -c cursor.ml
ocamlopt -for-pack Core -c statement.ml
ocamlopt -for-pack Core -c energy.mli
ocamlopt -for-pack Core -c energy.ml
ocamlopt -for-pack Core -c tape.mli
ocamlopt -for-pack Core -c tape.ml

ocamlopt -pack -o core.cmx \
map.cmx dots.cmx hand.cmx gene.cmx nature.cmx pigment.cmx side.cmx \
nucleus.cmx action.cmx tissue.cmx cursor.cmx statement.cmx energy.cmx \
tape.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
