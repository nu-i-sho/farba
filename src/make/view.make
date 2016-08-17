echo "------- View build started -------"

cd ../view

ocamlopt -for-pack View -c canvas.mli
ocamlopt -for-pack View -c canvas.ml
ocamlopt -for-pack View -c IMAGE_PROTOTYPE.ml
ocamlopt -for-pack View -c IMAGE_PROTOTYPES.ml
ocamlopt -for-pack View -c colorScheme.mli
ocamlopt -for-pack View -c colorScheme.ml
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
canvas.cmx IMAGE_PROTOTYPE.cmx IMAGE_PROTOTYPES.cmx \
colorScheme.cmx imagesStorage.cmx const.cmx scale.cmx pair.cmx \

mv view.cmx ../../bin/view.cmx
mv view.cmi ../../bin/view.cmi
mv view.o ../../bin/view.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ View build completed ------"
