echo "-------- Std build started -------"

cd ../std

ocamlopt -for-pack Std -c vector.mli
ocamlopt -for-pack Std -c vector.ml

ocamlopt -pack -o std.cmx \
vector.cmx \

mv std.cmx ../../bin/std.cmx
mv std.cmi ../../bin/std.cmi
mv std.o ../../bin/std.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------- Std build completed ------"
