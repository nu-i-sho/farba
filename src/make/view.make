echo "View build started"

cd ../view

ocamlopt -for-pack View -c canvas.mli
ocamlopt -for-pack View -c canvas.ml

ocamlopt -pack -o view.cmx \
canvas.cmx

mv view.cmx ../../bin/view.cmx
mv view.cmi ../../bin/view.cmi
mv view.o ../../bin/view.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "View build completed"
