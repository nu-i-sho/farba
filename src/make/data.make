echo "Data build started"

cd ../data

ocamlopt -c baseData.ml

ocamlopt baseData.cmx -o data.cmx data.ml

mv data.cmx ../../bin/data.cmx
mv data.cmi ../../bin/data.cmi
mv data.o ../../bin/data.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Data build completed"
