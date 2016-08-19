echo "------- View build started -------"

cd ../view

ocamlopt -I ../../bin -for-pack View -c commandExt.mli
ocamlopt -I ../../bin -for-pack View -c commandExt.ml
ocamlopt -for-pack View -c canvas.mli
ocamlopt -for-pack View -c canvas.ml
ocamlopt -for-pack View -c color.mli
ocamlopt -for-pack View -c color.ml
ocamlopt -for-pack View -c COLOR_SCHEME.ml
ocamlopt -for-pack View -c colorScheme.mli
ocamlopt -for-pack View -c colorScheme.ml
ocamlopt -I ../../bin -for-pack View -c imagesStorage.mli
ocamlopt -I ../../bin -for-pack View -c imagesStorage.ml
ocamlopt -for-pack View -c const.ml
ocamlopt -I ../../bin -for-pack View -c scale.mli
ocamlopt -I ../../bin -for-pack View -c scale.ml
ocamlopt -for-pack View -c pair.mli
ocamlopt -for-pack View -c pair.ml
ocamlopt -for-pack View -c tissueColorScheme.mli
ocamlopt -for-pack View -c tissueColorScheme.ml
ocamlopt -I ../../bin -for-pack View -c cellElementPrinter.mli
ocamlopt -I ../../bin -for-pack View -c cellElementPrinter.ml

ocamlopt -pack -o view.cmx \
commandExt.cmx canvas.cmx color.cmx COLOR_SCHEME.cmx \
colorScheme.cmx imagesStorage.cmx const.cmx scale.cmx pair.cmx \
tissueColorScheme.cmx cellElementPrinter.cmx

mv view.cmx ../../bin/view.cmx
mv view.cmi ../../bin/view.cmi
mv view.o ../../bin/view.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ View build completed ------"
