echo "------- Data build started -------"

cd ../data

ocamlopt -for-pack Data -c doubleable.ml
ocamlopt -for-pack Data -c dotsOfDice.ml
ocamlopt -for-pack Data -c pigment.ml
ocamlopt -for-pack Data -c hand.ml
ocamlopt -for-pack Data -c side.ml
ocamlopt -for-pack Data -c nucleus.ml
ocamlopt -for-pack Data -c cell.ml
ocamlopt -for-pack Data -c relation.ml
ocamlopt -for-pack Data -c action.ml
ocamlopt -for-pack Data -c command.ml
ocamlopt -for-pack Data -c weaverStage.ml
ocamlopt -for-pack Data -c fail.ml
ocamlopt -for-pack Data -c runtimeModeKind.ml
ocamlopt -for-pack Data -c runtimeMode.ml
ocamlopt -for-pack Data -c crumb.ml
ocamlopt -for-pack Data -c activeCrumbStage.ml
ocamlopt -for-pack Data -c crumbStage.ml
ocamlopt -for-pack Data -c stagedCrumb.ml
ocamlopt -for-pack Data -c crumbedCommand.ml
ocamlopt -for-pack Data -c programCrumb.ml
ocamlopt -for-pack Data -c programActiveCrumb.ml
ocamlopt -for-pack Data -c programItem.ml
ocamlopt -for-pack Data -c programActiveItem.ml
ocamlopt -I ../../bin -for-pack Data -c programLine.ml
ocamlopt -for-pack Data -c programActiveLine.ml
ocamlopt -for-pack Data -c itemInit.ml
ocamlopt -for-pack Data -c itemUpdate.ml
ocamlopt -for-pack Data -c programLineKind.ml
ocamlopt -for-pack Data -c programLineInit.ml
ocamlopt -for-pack Data -c programLineUpdate.ml
ocamlopt -for-pack Data -c callStackPoint.ml
ocamlopt -for-pack Data -c tissueItem.ml
ocamlopt -for-pack Data -c tissueItemInit.ml
ocamlopt -for-pack Data -c tissueItemUpdate.ml
ocamlopt -for-pack Data -c tissueStatistics.ml
ocamlopt -for-pack Data -c actsStatistics.ml
ocamlopt -for-pack Data -c commandsStatistics.ml
ocamlopt -for-pack Data -c weaverStatistics.ml
ocamlopt -for-pack Data -c statistics.ml

ocamlopt -pack -o data.cmx \
doubleable.cmx dotsOfDice.cmx pigment.cmx hand.cmx side.cmx \
nucleus.cmx cell.cmx relation.cmx action.cmx command.cmx \
fail.cmx weaverStage.cmx runtimeModeKind.cmx runtimeMode.cmx \
crumb.cmx activeCrumbStage.cmx crumbStage.cmx stagedCrumb.cmx \
crumbedCommand.cmx programCrumb.cmx programActiveCrumb.cmx \
programItem.cmx programActiveItem.cmx programLine.cmx \
programActiveLine.cmx itemInit.cmx itemUpdate.cmx \
programLineKind.cmx programLineInit.cmx programLineUpdate.cmx \
callStackPoint.cmx tissueItem.cmx tissueItemInit.cmx \
tissueItemUpdate.cmx tissueStatistics.cmx actsStatistics.cmx \
commandsStatistics.cmx weaverStatistics.cmx statistics.cmx

mv data.cmx ../../bin/data.cmx
mv data.cmi ../../bin/data.cmi
mv data.o ../../bin/data.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Data build completed ------"
