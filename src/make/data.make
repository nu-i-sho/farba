echo "Data build started"

cd ../data

ocamlopt -for-pack Data -c shared.ml

ocamlopt shared.cmx -pack -o data.cmx

mv data.cmx ../../bin/data.cmx
mv data.cmi ../../bin/data.cmi
mv data.o ../../bin/data.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Data build completed"
