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
ocamlopt -I ../../bin -for-pack Core -c tissueItem.ml
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
ocamlopt -I ../../bin -for-pack Core -c tissueItemUpdateExt.mli
ocamlopt -I ../../bin -for-pack Core -c tissueItemUpdateExt.ml
ocamlopt -I ../../bin -for-pack Core -c tissueObservableWeaver.mli
ocamlopt -I ../../bin -for-pack Core -c tissueObservableWeaver.ml
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
ocamlopt -for-pack Core -c tickStatus.mli
ocamlopt -for-pack Core -c tickStatus.ml
ocamlopt -I ../../bin -for-pack Core -c RUNTIME.ml
ocamlopt -I ../../bin -for-pack Core -c weaverCommander.mli
ocamlopt -I ../../bin -for-pack Core -c weaverCommander.ml
ocamlopt -for-pack Core -c runtime.mli
ocamlopt -I ../../bin -for-pack Core -c runtime.ml
ocamlopt -I ../../bin -for-pack Core -c commandsCounter.mli
ocamlopt -I ../../bin -for-pack Core -c commandsCounter.ml
ocamlopt -I ../../bin -for-pack Core -c statisticableRuntime.mli
ocamlopt -I ../../bin -for-pack Core -c statisticableRuntime.ml

ocamlopt -pack -o core.cmx dotsOfDiceExt.cmx pigmentExt.cmx \
sideExt.cmx nucleusExt.cmx index.cmx levelPath.cmx level.cmx \
tissueItem.cmx tissue.cmx weaverAct.cmx statused.cmx \
passStatus.cmx moveStatus.cmx weaverActsCounter.cmx WEAVER.cmx \
weaverStatistics.cmx STATISTICABLE_WEAVER.cmx weaver.cmx \
tissueCounter.cmx statisticableWeaver.cmx \
tissueObservableWeaver.cmx BREADCRUMBS.cmx breadcrumbs.cmx \
observableBreadcrumbs.cmx solutionLabel.cmx commandExt.cmx \
solution.cmx tickStatus.cmx RUNTIME.cmx weaverCommander.cmx \
runtime.cmx commandsCounter.cmx statisticableRuntime.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Core build completed ------"
