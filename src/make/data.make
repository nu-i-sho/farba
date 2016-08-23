echo "------- Data build started -------"

cd ../data

ocamlopt -for-pack Data -c dotsOfDice.ml
ocamlopt -for-pack Data -c callStackPoint.ml
ocamlopt -for-pack Data -c pigment.ml
ocamlopt -for-pack Data -c hand.ml
ocamlopt -for-pack Data -c side.ml
ocamlopt -for-pack Data -c nucleus.ml
ocamlopt -for-pack Data -c cell.ml
ocamlopt -for-pack Data -c relation.ml
ocamlopt -for-pack Data -c commandKind.ml
ocamlopt -for-pack Data -c command.ml
ocamlopt -for-pack Data -c fail.ml
ocamlopt -for-pack Data -c runtimeModeKind.ml
ocamlopt -for-pack Data -c runtimeMode.ml
ocamlopt -for-pack Data -c runtimePoint.ml
ocamlopt -for-pack Data -c tissueItemInit.ml
ocamlopt -for-pack Data -c tissueItemUpdate.ml
ocamlopt -for-pack Data -c tissueStatistics.ml
ocamlopt -for-pack Data -c actsStatistics.ml
ocamlopt -for-pack Data -c commandsStatistics.ml
ocamlopt -for-pack Data -c statistics.ml

ocamlopt -pack -o data.cmx \
dotsOfDice.cmx callStackPoint.cmx pigment.cmx hand.cmx side.cmx \
nucleus.cmx cell.cmx relation.cmx commandKind.cmx command.cmx \
fail.cmx runtimeModeKind.cmx runtimeMode.cmx runtimePoint.cmx \
tissueItemInit.cmx tissueItemUpdate.cmx tissueStatistics.cmx \
actsStatistics.cmx commandsStatistics.cmx statistics.cmx

mv data.cmx ../../bin/data.cmx
mv data.cmi ../../bin/data.cmi
mv data.o ../../bin/data.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Data build completed ------"
