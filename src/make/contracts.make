echo "----- Contracts build started ----"

cd ../contracts

ocamlopt -I ../../bin -for-pack Contracts -c TISSUE_OBSERVER.ml
ocamlopt -I ../../bin -for-pack Contracts -c CALL_STACK_OBSERVER.ml

ocamlopt -pack -o contracts.cmx \
TISSUE_OBSERVER.cmx CALL_STACK_OBSERVER.cmx

mv contracts.cmx ../../bin/contracts.cmx
mv contracts.cmi ../../bin/contracts.cmi
mv contracts.o ../../bin/contracts.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "---- Contracts build completed ---"
