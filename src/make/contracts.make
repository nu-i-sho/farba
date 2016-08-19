echo "----- Contracts build started ----"

cd ../contracts

ocamlopt -I ../../bin -for-pack CONTRACTS -c TISSUE_OBSERVER.ml
ocamlopt -I ../../bin -for-pack CONTRACTS -c CALL_STACK_OBSERVER.ml

ocamlopt -pack -o CONTRACTS.cmx \
TISSUE_OBSERVER.cmx CALL_STACK_OBSERVER.cmx

mv CONTRACTS.cmx ../../bin/CONTRACTS.cmx
mv CONTRACTS.cmi ../../bin/CONTRACTS.cmi
mv CONTRACTS.o ../../bin/CONTRACTS.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "---- Contracts build completed ---"
