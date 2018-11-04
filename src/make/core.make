echo "Core build started"

cd ../core

ocamlopt -I ../../bin -for-pack Core -c dots.mli
ocamlopt -I ../../bin -for-pack Core -c dots.ml
ocamlopt -for-pack Core -c common.ml
ocamlopt -I ../../bin -for-pack Core -c tape.mli
ocamlopt -I ../../bin -for-pack Core -c -w -8 tape.ml
ocamlopt -I ../../bin -for-pack Core -c energy.mli
ocamlopt -I ../../bin -for-pack Core -c energy.ml
ocamlopt -I ../../bin -for-pack Core -c args.mli
ocamlopt -I ../../bin -for-pack Core -c args.ml
ocamlopt -I ../../bin -for-pack Core -c loop.mli
ocamlopt -I ../../bin -for-pack Core -c loop.ml
ocamlopt -for-pack Core -c pigment.mli
ocamlopt -for-pack Core -c pigment.ml
ocamlopt -for-pack Core -c side.mli
ocamlopt -for-pack Core -c side.ml
ocamlopt -for-pack Core -c nucleus.mli
ocamlopt -for-pack Core -c nucleus.ml
ocamlopt -I ../../bin -for-pack Core -c tissue.mli
ocamlopt -I ../../bin -for-pack Core -c tissue.ml
ocamlopt -I ../../bin -for-pack Core -c cursor.mli
ocamlopt -I ../../bin -for-pack Core -c cursor.ml
ocamlopt -for-pack Core -c solution.mli
ocamlopt -for-pack Core -c solution.ml

ocamlopt -pack -o core.cmx \
dots.cmx common.cmx tape.cmx energy.cmx args.cmx loop.cmx \
pigment.cmx side.cmx tissue.cmx cursor.cmx solution.cmx

mv core.cmx ../../bin/core.cmxc
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
