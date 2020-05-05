echo "Core build started"

cd ../core

ocamlopt -I ../../bin -for-pack Core -c dots.mli
ocamlopt -I ../../bin -for-pack Core -c dots.ml
ocamlopt -for-pack Core -c hand.ml
ocamlopt -for-pack Core -c gene.ml
ocamlopt -for-pack Core -c nature.ml
ocamlopt -for-pack Core -c action.ml
ocamlopt -for-pack Core -c command.ml
ocamlopt -for-pack Core -c availability.ml
ocamlopt -for-pack Core -c statement.ml
ocamlopt -for-pack Core -c source.ml
ocamlopt -for-pack Core -c runtime.ml

#ocamlopt -for-pack Core -c common.ml
#ocamlopt -I ../../bin -for-pack Core -c tape.mli
#ocamlopt -I ../../bin -for-pack Core -c -w -8 tape.ml
#ocamlopt -I ../../bin -for-pack Core -c args.mli
#ocamlopt -I ../../bin -for-pack Core -c args.ml
#ocamlopt -I ../../bin -for-pack Core -c loop.mli
#ocamlopt -I ../../bin -for-pack Core -c loop.ml
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
ocamlopt -for-pack Core -c energy.mli
ocamlopt -for-pack Core -c energy.ml
ocamlopt -for-pack Core -c loop.mli
ocamlopt -for-pack Core -c loop.ml
ocamlopt -for-pack Core -c tape.mli
ocamlopt -for-pack Core -c tape.ml
#ocamlopt -for-pack Core -c solution.mli
#ocamlopt -for-pack Core -c solution.ml

ocamlopt -pack -o core.cmx \
dots.cmx hand.cmx gene.cmx nature.cmx action.cmx command.cmx \
availability.cmx statement.cmx source.cmx runtime.cmx pigment.cmx \
side.cmx nucleus.cmx tissue.cmx cursor.cmx energy.cmx loop.cmx
#tape.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
