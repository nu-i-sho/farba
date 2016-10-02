echo "VIEW build started"

cd ../VIEW

ocamlopt -I ../../bin -for-pack VIEW -c TISSUE.ml
ocamlopt -I ../../bin -for-pack VIEW -c PROGRAM.ml

ocamlopt -pack -o VIEW.cmx \
TISSUE.cmx PROGRAM.cmx

mv VIEW.cmx ../../bin/VIEW.cmx
mv VIEW.cmi ../../bin/VIEW.cmi
mv VIEW.o ../../bin/VIEW.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "VIEW build completed"
