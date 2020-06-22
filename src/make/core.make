echo "Core build started"

cd ../core

ocamlopt -for-pack Core -c list.mli
ocamlopt -for-pack Core -c list.ml 
ocamlopt -for-pack Core -c map.mli
ocamlopt -for-pack Core -c map.ml
ocamlopt -for-pack Core -c seq.mli
ocamlopt -for-pack Core -c seq.ml
ocamlopt -for-pack Core -c IO.ml
ocamlopt -for-pack Core -c int.mli
ocamlopt -for-pack Core -c int.ml
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
ocamlopt -for-pack Core -c command.ml
ocamlopt -for-pack Core -c tissue.mli
ocamlopt -for-pack Core -c tissue.ml
ocamlopt -for-pack Core -c cursor.mli
ocamlopt -for-pack Core -c cursor.ml
ocamlopt -for-pack Core -c energy.mli
ocamlopt -for-pack Core -c energy.ml
ocamlopt -for-pack Core -c statement.ml
ocamlopt -for-pack Core -c source.mli
ocamlopt -for-pack Core -c source.ml
ocamlopt -for-pack Core -c tape.mli
ocamlopt -for-pack Core -c tape.ml
ocamlopt -for-pack Core -c processor.mli
ocamlopt -for-pack Core -c processor.ml
ocamlopt -for-pack Core -c OBSERV.ml
ocamlopt -for-pack Core -c subject.mli
ocamlopt -for-pack Core -c subject.ml
ocamlopt -for-pack Core -c program.mli
ocamlopt -for-pack Core -c program.ml

ocamlopt -pack -o core.cmx \
list.cmx map.cmx seq.cmx IO.cmx int.cmx dots.cmx hand.cmx gene.cmx nature.cmx \
pigment.cmx side.cmx nucleus.cmx command.cmx tissue.cmx cursor.cmx energy.cmx \
source.cmx statement.cmx tape.cmx processor.cmx OBSERV.cmx subject.cmx \
program.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
