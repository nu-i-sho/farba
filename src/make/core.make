echo "Core build started"

cd ../core

ocamlopt -I ../../bin -for-pack Core -c side.mli
ocamlopt -I ../../bin -for-pack Core -c side.ml
ocamlopt -I ../../bin -for-pack Core -c cytoplasm.mli
ocamlopt -I ../../bin -for-pack Core -c cytoplasm.ml
ocamlopt -I ../../bin -for-pack Core -c nucleus.mli
ocamlopt -I ../../bin -for-pack Core -c nucleus.ml
ocamlopt -I ../../bin -for-pack Core -c dots.mli
ocamlopt -I ../../bin -for-pack Core -c dots.ml
ocamlopt -I ../../bin -for-pack Core -c energizer.mli
ocamlopt -I ../../bin -for-pack Core -c energizer.ml
ocamlopt -I ../../bin -for-pack Core -c energyCrumbs.mli
ocamlopt -I ../../bin -for-pack Core -c energyCrumbs.ml
ocamlopt -I ../../bin -for-pack Core -c arg.mli
ocamlopt -I ../../bin -for-pack Core -c arg.ml
ocamlopt -I ../../bin -for-pack Core -c args.mli
ocamlopt -I ../../bin -for-pack Core -c args.ml
ocamlopt -I ../../bin -for-pack Core -c argsCrumbs.mli
ocamlopt -I ../../bin -for-pack Core -c argsCrumbs.ml
ocamlopt -I ../../bin -for-pack Core -c loopCrumbs.mli
ocamlopt -I ../../bin -for-pack Core -c loopCrumbs.ml
ocamlopt -I ../../bin -for-pack Core -c level.mli
ocamlopt -I ../../bin -for-pack Core -c level.ml
ocamlopt -I ../../bin -for-pack Core -c tissue.mli
ocamlopt -I ../../bin -for-pack Core -c tissue.ml
ocamlopt -I ../../bin -for-pack Core -c weaver.mli
ocamlopt -I ../../bin -for-pack Core -c weaver.ml
ocamlopt -I ../../bin -for-pack Core -c tissueCounter.mli
ocamlopt -I ../../bin -for-pack Core -c tissueCounter.ml
ocamlopt -I ../../bin -for-pack Core -c statisticableWeaver.mli
ocamlopt -I ../../bin -for-pack Core -c statisticableWeaver.ml

ocamlopt -pack -o core.cmx \
side.cmx nucleus.cmx dots.cmx energizer.cmx energyCrumbs.cmx \
arg.cmx args.cmx argsCrumbs.cmx loopCrumbs.cmx level.cmx \
tissue.cmx weaver.cmx tissueCounter.cmx statisticableWeaver.cmx

mv core.cmx ../../bin/core.cmxc
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
