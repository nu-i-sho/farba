echo "Data build started"

cd ../data

ocamlopt -I ../../bin -for-pack Data -c shared.ml
ocamlopt -I ../../bin -for-pack Data -c program.ml
ocamlopt -for-pack Data -c tissue.ml
ocamlopt -for-pack Data -c statistics.ml

ocamlopt -pack -o data.cmx \
shared.cmx program.cmx tissue.cmx statistics.cmx

mv data.cmx ../../bin/data.cmx
mv data.cmi ../../bin/data.cmi
mv data.o ../../bin/data.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Data build completed"
