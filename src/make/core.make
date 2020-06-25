echo "Core build started"

cd ../core

ocamlopt -for-pack Game.Core -c list.mli
ocamlopt -for-pack Game.Core -c list.ml 
ocamlopt -for-pack Game.Core -c map.mli
ocamlopt -for-pack Game.Core -c map.ml
ocamlopt -for-pack Game.Core -c seq.mli
ocamlopt -for-pack Game.Core -c seq.ml
ocamlopt -for-pack Game.Core -c IO.ml
ocamlopt -for-pack Game.Core -c int.mli
ocamlopt -for-pack Game.Core -c int.ml
ocamlopt -for-pack Game.Core -c dots.mli
ocamlopt -for-pack Game.Core -c dots.ml
ocamlopt -for-pack Game.Core -c hand.ml
ocamlopt -for-pack Game.Core -c gene.ml
ocamlopt -for-pack Game.Core -c nature.ml
ocamlopt -for-pack Game.Core -c pigment.mli
ocamlopt -for-pack Game.Core -c pigment.ml
ocamlopt -for-pack Game.Core -c side.mli
ocamlopt -for-pack Game.Core -c side.ml
ocamlopt -for-pack Game.Core -c nucleus.mli
ocamlopt -for-pack Game.Core -c nucleus.ml
ocamlopt -for-pack Game.Core -c command.ml
ocamlopt -for-pack Game.Core -c tissue.mli
ocamlopt -for-pack Game.Core -c tissue.ml
ocamlopt -for-pack Game.Core -c cursor.mli
ocamlopt -for-pack Game.Core -c cursor.ml
ocamlopt -for-pack Game.Core -c energy.mli
ocamlopt -for-pack Game.Core -c energy.ml
ocamlopt -for-pack Game.Core -c statement.ml
ocamlopt -for-pack Game.Core -c source.mli
ocamlopt -for-pack Game.Core -c source.ml
ocamlopt -for-pack Game.Core -c tape.mli
ocamlopt -for-pack Game.Core -c tape.ml
ocamlopt -for-pack Game.Core -c processor.mli
ocamlopt -for-pack Game.Core -c processor.ml
ocamlopt -for-pack Game.Core -c OBSERV.ml
ocamlopt -for-pack Game.Core -c subject.mli
ocamlopt -for-pack Game.Core -c subject.ml
ocamlopt -for-pack Game.Core -c program.mli
ocamlopt -for-pack Game.Core -c program.ml

ocamlopt -for-pack Game -pack -o core.cmx \
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
