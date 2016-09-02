echo "------- Core build started -------"

cd ../core

ocamlopt -I ../../bin -for-pack Core -c dotsOfDiceExt.mli
ocamlopt -I ../../bin -for-pack Core -c dotsOfDiceExt.ml
ocamlopt -I ../../bin -for-pack Core -c levelPath.ml
ocamlopt -I ../../bin -for-pack Core -c pigmentExt.mli
ocamlopt -I ../../bin -for-pack Core -c pigmentExt.ml
ocamlopt -I ../../bin -for-pack Core -c sideExt.mli
ocamlopt -I ../../bin -for-pack Core -c sideExt.ml
ocamlopt -I ../../bin -for-pack Core -c nucleusExt.mli
ocamlopt -I ../../bin -for-pack Core -c nucleusExt.ml
ocamlopt -I ../../bin -for-pack Core -c index.mli
ocamlopt -I ../../bin -for-pack Core -c index.ml
ocamlopt -I ../../bin -for-pack Core -c levelPath.ml
ocamlopt -I ../../bin -for-pack Core -c level.mli
ocamlopt -I ../../bin -for-pack Core -c level.ml
ocamlopt -I ../../bin -for-pack Core -c tissue.mli
ocamlopt -I ../../bin -for-pack Core -c tissue.ml
ocamlopt -I ../../bin -for-pack Core -c tissueCounter.mli
ocamlopt -I ../../bin -for-pack Core -c tissueCounter.ml
ocamlopt -for-pack Core -c weaverAct.ml
ocamlopt -I ../../bin -for-pack Core -c weaverActsCounter.mli
ocamlopt -I ../../bin -for-pack Core -c weaverActsCounter.ml
ocamlopt -I ../../bin -for-pack Core -c weaver.mli
ocamlopt -I ../../bin -for-pack Core -c weaver.ml
ocamlopt -I ../../bin -for-pack Core -c BREADCRUMBS.ml
ocamlopt -I ../../bin -for-pack Core -c breadcrumbs.mli
ocamlopt -I ../../bin -for-pack Core -c breadcrumbs.ml
ocamlopt -I ../../bin -for-pack Core -c observableBreadcrumbs.mli
ocamlopt -I ../../bin -for-pack Core -c observableBreadcrumbs.ml
ocamlopt -I ../../bin -for-pack Core -c solutionLabel.ml
ocamlopt -I ../../bin -for-pack Core -c commandExt.mli
ocamlopt -I ../../bin -for-pack Core -c commandExt.ml
ocamlopt -I ../../bin -for-pack Core -c solution.mli
ocamlopt -I ../../bin -for-pack Core -c solution.ml
ocamlopt -I ../../bin -for-pack Core -c runtimeStage.mli
ocamlopt -I ../../bin -for-pack Core -c runtimeStage.ml
ocamlopt -I ../../bin -for-pack Core -c RUNTIME.ml
ocamlopt -I ../../bin -for-pack Core -c runtime.mli
ocamlopt -I ../../bin -for-pack Core -c runtime.ml
ocamlopt -I ../../bin -for-pack Core -c commandsCounter.mli
ocamlopt -I ../../bin -for-pack Core -c commandsCounter.ml
ocamlopt -I ../../bin -for-pack Core -c statisticableRuntime.mli
ocamlopt -I ../../bin -for-pack Core -c statisticableRuntime.ml

ocamlopt -pack -o core.cmx dotsOfDiceExt.cmx pigmentExt.cmx \
sideExt.cmx nucleusExt.cmx index.cmx levelPath.cmx level.cmx \
tissue.cmx tissueCounter.cmx weaverAct.cmx weaverActsCounter.cmx \
weaver.cmx BREADCRUMBS.cmx breadcrumbs.cmx \
observableBreadcrumbs.cmx solutionLabel.cmx commandExt.cmx \
solution.cmx runtimeStage.cmx RUNTIME.cmx runtime.cmx \
commandsCounter.cmx statisticableRuntime.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Core build completed ------"
