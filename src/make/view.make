echo "------- View build started -------"

cd ../view

ocamlopt -for-pack View -c commandKind.ml
ocamlopt -I ../../bin -for-pack View -c commandExt.mli
ocamlopt -I ../../bin -for-pack View -c commandExt.ml
ocamlopt -for-pack View -c canvas.mli
ocamlopt -for-pack View -c canvas.ml
ocamlopt -for-pack View -c color.mli
ocamlopt -for-pack View -c color.ml
ocamlopt -for-pack View -c COLOR_SCHEME.ml
ocamlopt -for-pack View -c tissueColorScheme.mli
ocamlopt -for-pack View -c tissueColorScheme.ml
ocamlopt -for-pack View -c commandColorScheme.mli
ocamlopt -I ../../bin -for-pack View -c commandColorScheme.ml
ocamlopt -for-pack View -c callStackPointColorScheme.mli
ocamlopt -I ../../bin -for-pack View -c callStackPointColorScheme.ml
ocamlopt -I ../../bin -for-pack View -c image.mli
ocamlopt -I ../../bin -for-pack View -c image.ml
ocamlopt -for-pack View -c runtimeModeKind.mli
ocamlopt -for-pack View -c runtimeModeKind.ml
ocamlopt -I ../../bin -for-pack View -c runtimeModeExt.mli
ocamlopt -I ../../bin -for-pack View -c runtimeModeExt.ml
ocamlopt -for-pack View -c stateUpdatableResult.ml
ocamlopt -I ../../bin -for-pack View -c IMAGES_PROVIDER.ml
ocamlopt -I ../../bin -for-pack View -c imagesProvider.mli
ocamlopt -I ../../bin -for-pack View -c imagesProvider.ml
ocamlopt -I ../../bin -for-pack View -c imagesStorage.mli
ocamlopt -I ../../bin -for-pack View -c imagesStorage.ml
ocamlopt -for-pack View -c const.ml
ocamlopt -I ../../bin -for-pack View -c scale.mli
ocamlopt -I ../../bin -for-pack View -c scale.ml
ocamlopt -for-pack View -c pair.mli
ocamlopt -for-pack View -c pair.ml
ocamlopt -I ../../bin -for-pack View -c cellElementPrinter.mli
ocamlopt -I ../../bin -for-pack View -c cellElementPrinter.ml

ocamlopt -pack -o view.cmx \
commandKind.cmx commandExt.cmx canvas.cmx color.cmx \
COLOR_SCHEME.cmx tissueColorScheme.cmx commandColorScheme.cmx \
callStackPointColorScheme.cmx image.cmx runtimeModeKind.cmx \
runtimeModeExt.cmx stateUpdatableResult.cmx IMAGES_PROVIDER.cmx \
imagesStorage.cmx imagesProvider.cmx const.cmx scale.cmx pair.cmx \
cellElementPrinter.cmx

mv view.cmx ../../bin/view.cmx
mv view.cmi ../../bin/view.cmi
mv view.o ../../bin/view.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ View build completed ------"
