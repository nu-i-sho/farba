echo "------- Core build started -------"

cd ../core

ocamlopt -for-pack Core -c MODULE.ml
ocamlopt -I ../../bin -for-pack Core -c dotsOfDice.mli
ocamlopt -I ../../bin -for-pack Core -c dotsOfDice.ml
ocamlopt -for-pack Core -c levelPath.ml
ocamlopt -for-pack Core -c DOTS_OF_DICE_NODE.ml
ocamlopt -for-pack Core -c LEVEL_SOURCE.ml
ocamlopt -for-pack Core -c LEVELS_SOURCE_TREE.ml
ocamlopt -for-pack Core -c dotsOfDiceNodeMap.mli
ocamlopt -I ../../bin -for-pack Core -c dotsOfDiceNodeMap.ml
ocamlopt -I ../../bin -for-pack Core -c pigment.mli
ocamlopt -I ../../bin -for-pack Core -c pigment.ml
ocamlopt -I ../../bin -for-pack Core -c side.mli
ocamlopt -I ../../bin -for-pack Core -c side.ml
ocamlopt -I ../../bin -for-pack Core -c nucleus.mli
ocamlopt -I ../../bin -for-pack Core -c nucleus.ml
ocamlopt -for-pack Core -c index.mli
ocamlopt -I ../../bin -for-pack Core -c index.ml
ocamlopt -for-pack Core -c intMap.mli
ocamlopt -for-pack Core -c intMap.ml
ocamlopt -for-pack Core -c matrix.mli
ocamlopt -for-pack Core -c matrix.ml
ocamlopt -for-pack Core -c level.mli
ocamlopt -I ../../bin -for-pack Core -c level.ml
ocamlopt -I ../../bin -for-pack Core -c tissue.mli
ocamlopt -I ../../bin -for-pack Core -c tissue.ml
ocamlopt -for-pack Core -c weaverAct.ml
ocamlopt -for-pack Core -c weavingResult.ml
ocamlopt -I ../../bin -for-pack Core -c weaverActsCounter.mli
ocamlopt -I ../../bin -for-pack Core -c weaverActsCounter.ml
ocamlopt -I ../../bin -for-pack Core -c WEAVER.ml
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
ocamlopt -I ../../bin -for-pack Core -c config.ml
ocamlopt -I ../../bin -for-pack Core -c programLabel.ml

ocamlopt -pack -o core.cmx \
MODULE.cmx dotsOfDice.cmx DOTS_OF_DICE_NODE.cmx LEVEL_SOURCE.cmx \
LEVELS_SOURCE_TREE.cmx dotsOfDiceNodeMap.cmx pigment.cmx \
side.cmx nucleus.cmx index.cmx intMap.cmx matrix.cmx level.cmx \
tissue.cmx weaverAct.cmx weavingResult.cmx weaverActsCounter.cmx \
WEAVER.cmx STATISTICABLE_WEAVER.cmx weaver.cmx \
tissueCounter.cmx statisticableWeaver.cmx \
tissueObservableWeaver.cmx callStack.cmx config.cmx \
programLabel.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Core build completed ------"
