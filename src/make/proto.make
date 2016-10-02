echo "Proto build started"

cd ../proto

ocamlopt -I ../../bin -for-pack Proto -c pigment.mli
ocamlopt -I ../../bin -for-pack Proto -c pigment.ml

ocamlopt -pack -o proto.cmx \
pigment.cmx

mv proto.cmx ../../bin/proto.cmx
mv proto.cmi ../../bin/proto.cmi
mv proto.o ../../bin/proto.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Proto build completed"
