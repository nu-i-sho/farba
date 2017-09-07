echo "Core build started"

cd ../core

ocamlopt -I ../../bin -for-pack Core -c dots.mli
ocamlopt -I ../../bin -for-pack Core -c dots.ml
ocamlopt -for-pack Core -c common.ml
ocamlopt -for-pack Core -c die.ml
ocamlopt -for-pack Core -c energyDice.mli
ocamlopt -I ../../bin -for-pack Core -c energyDice.ml
ocamlopt -I ../../bin -for-pack Core -c args.mli
ocamlopt -I ../../bin -for-pack Core -c args.ml
ocamlopt -I ../../bin -for-pack Core -c stash.mli
ocamlopt -I ../../bin -for-pack Core -c stash.ml
ocamlopt -I ../../bin -for-pack Core -c loop.mli
ocamlopt -I ../../bin -for-pack Core -c loop.ml
ocamlopt -for-pack Core -c pigment.mli
ocamlopt -for-pack Core -c pigment.ml
ocamlopt -for-pack Core -c side.mli
ocamlopt -for-pack Core -c side.ml

ocamlopt -pack -o core.cmx \
dots.cmx common.cmx die.cmx energyDice.cmx args.cmx stash.cmx \
loop.cmx pigment.cmx side.cmx

mv core.cmx ../../bin/core.cmxc
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
