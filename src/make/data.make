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
ocamlopt -for-pack Data -c command.ml
ocamlopt -for-pack Data -c fail.ml
ocamlopt -for-pack Data -c runtimeMode.ml
ocamlopt -for-pack Data -c runtimePoint.ml
ocamlopt -for-pack Data -c tissueItem.ml
ocamlopt -for-pack Data -c tissueStatistics.ml
ocamlopt -for-pack Data -c actsStatistics.ml
ocamlopt -for-pack Data -c commandsStatistics.ml
ocamlopt -for-pack Data -c statistics.ml

ocamlopt -pack -o data.cmx \
actsStatistics.cmx callStackPoint.cmx cell.cmx command.cmx \
commandsStatistics.cmx dotsOfDice.cmx fail.cmx hand.cmx \
nucleus.cmx pigment.cmx relation.cmx runtimeMode.cmx \
runtimePoint.cmx side.cmx statistics.cmx tissueItem.cmx \
tissueStatistics.cmx

mv data.cmx ../../bin/data.cmx
mv data.cmi ../../bin/data.cmi
mv data.o ../../bin/data.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Data build completed ------"
