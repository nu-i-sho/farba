echo "Core build started"

cd ../core

ocamlopt -for-pack Core -c ENERGY_DICE.ml
ocamlopt -I ../../bin -for-pack Core -c energyDots.mli
ocamlopt -I ../../bin -for-pack Core -c energyDots.ml
ocamlopt -I ../../bin -for-pack Core -c energyDice.mli
ocamlopt -I ../../bin -for-pack Core -c energyDice.ml

ocamlopt -pack -o core.cmx \
ENERGY_DICE.cmx energyDots.cmx energyDice.cmx

mv core.cmx ../../bin/core.cmxc
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
