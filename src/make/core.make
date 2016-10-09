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
ocamlopt -I ../../bin -for-pack Core -c crumbs.mli
ocamlopt -I ../../bin -for-pack Core -c crumbs.ml
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
side.cmx nucleus.cmx dots.cmx crumbs.cmx level.cmx tissue.cmx \
weaver.cmx tissueCounter.cmx statisticableWeaver.cmx

mv core.cmx ../../bin/core.cmxc
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build completed"
