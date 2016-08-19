echo "------- Core build started -------"

cd ../core

ocamlopt -for-pack Core -c MODULE.ml
ocamlopt -I ../../bin -for-pack Core -c dotsOfDiceExt.mli
ocamlopt -I ../../bin -for-pack Core -c dotsOfDiceExt.ml
ocamlopt -I ../../bin -for-pack Core -c levelPath.ml
ocamlopt -for-pack Core -c DOTS_OF_DICE_NODE.ml
ocamlopt -for-pack Core -c LEVEL_SOURCE.ml
ocamlopt -for-pack Core -c LEVELS_SOURCE_TREE.ml
ocamlopt -I ../../bin -for-pack Core -c dotsOfDiceNodeMap.mli
ocamlopt -I ../../bin -for-pack Core -c dotsOfDiceNodeMap.ml
ocamlopt -I ../../bin -for-pack Core -c pigmentExt.mli
ocamlopt -I ../../bin -for-pack Core -c pigmentExt.ml
ocamlopt -I ../../bin -for-pack Core -c sideExt.mli
ocamlopt -I ../../bin -for-pack Core -c sideExt.ml
ocamlopt -I ../../bin -for-pack Core -c nucleusExt.mli
ocamlopt -I ../../bin -for-pack Core -c nucleusExt.ml
ocamlopt -I ../../bin -for-pack Core -c index.mli
ocamlopt -I ../../bin -for-pack Core -c index.ml
ocamlopt -for-pack Core -c intMap.mli
ocamlopt -for-pack Core -c intMap.ml
ocamlopt -for-pack Core -c matrix.mli
ocamlopt -for-pack Core -c matrix.ml
ocamlopt -I ../../bin -for-pack Core -c levelPath.ml
ocamlopt -I ../../bin -for-pack Core -c level.mli
ocamlopt -I ../../bin -for-pack Core -c level.ml
ocamlopt -I ../../bin -for-pack Core -c tissue.mli
ocamlopt -I ../../bin -for-pack Core -c tissue.ml
ocamlopt -for-pack Core -c weaverAct.ml
ocamlopt -for-pack Core -c statused.mli
ocamlopt -for-pack Core -c statused.ml
ocamlopt -for-pack Core -c moveStatus.ml
ocamlopt -for-pack Core -c passStatus.ml
ocamlopt -I ../../bin -for-pack Core -c weaverActsCounter.mli
ocamlopt -I ../../bin -for-pack Core -c weaverActsCounter.ml
ocamlopt -I ../../bin -for-pack Core -c WEAVER.ml
ocamlopt -I ../../bin -for-pack Core -c weaverStatistics.ml
ocamlopt -I ../../bin -for-pack Core -c STATISTICABLE_WEAVER.ml
ocamlopt -for-pack Core -c weaver.mli
ocamlopt -I ../../bin -for-pack Core -c weaver.ml
ocamlopt -I ../../bin -for-pack Core -c tissueCounter.mli
ocamlopt -I ../../bin -for-pack Core -c tissueCounter.ml
ocamlopt -for-pack Core -c statisticableWeaver.mli
ocamlopt -I ../../bin -for-pack Core -c statisticableWeaver.ml
ocamlopt -I ../../bin -for-pack Core -c tissueObservableWeaver.mli
ocamlopt -I ../../bin -for-pack Core -c tissueObservableWeaver.ml
ocamlopt -I ../../bin -for-pack Core -c callStack.mli
ocamlopt -I ../../bin -for-pack Core -c callStack.ml
ocamlopt -I ../../bin -for-pack Core -c solutionLabel.ml
ocamlopt -I ../../bin -for-pack Core -c commandExt.mli
ocamlopt -I ../../bin -for-pack Core -c commandExt.ml
ocamlopt -I ../../bin -for-pack Core -c solution.mli
ocamlopt -I ../../bin -for-pack Core -c solution.ml
ocamlopt -for-pack Core -c tickStatus.ml
ocamlopt -I ../../bin -for-pack Core -c RUNTIME.ml
ocamlopt -for-pack Core -c runtime.mli
ocamlopt -I ../../bin -for-pack Core -c runtime.ml
ocamlopt -I ../../bin -for-pack Core -c commandsCounter.mli
ocamlopt -I ../../bin -for-pack Core -c commandsCounter.ml
ocamlopt -I ../../bin -for-pack Core -c STATISTICABLE_RUNTIME.ml
ocamlopt -for-pack Core -c statisticableRuntime.mli
ocamlopt -I ../../bin -for-pack Core -c statisticableRuntime.ml
ocamlopt -I ../../bin -for-pack Core -c observableRuntime.mli
ocamlopt -I ../../bin -for-pack Core -c observableRuntime.ml

ocamlopt -pack -o core.cmx \
MODULE.cmx dotsOfDiceExt.cmx DOTS_OF_DICE_NODE.cmx \
LEVEL_SOURCE.cmx LEVELS_SOURCE_TREE.cmx dotsOfDiceNodeMap.cmx \
pigmentExt.cmx sideExt.cmx nucleusExt.cmx index.cmx intMap.cmx \
matrix.cmx levelPath.cmx level.cmx tissue.cmx weaverAct.cmx \
statused.cmx passStatus.cmx moveStatus.cmx weaverActsCounter.cmx \
WEAVER.cmx weaverStatistics.cmx STATISTICABLE_WEAVER.cmx \
weaver.cmx tissueCounter.cmx statisticableWeaver.cmx \
tissueObservableWeaver.cmx callStack.cmx solutionLabel.cmx \
commandExt.cmx solution.cmx tickStatus.cmx RUNTIME.cmx runtime.cmx \
commandsCounter.cmx STATISTICABLE_RUNTIME.cmx \
statisticableRuntime.cmx observableRuntime.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Core build completed ------"
