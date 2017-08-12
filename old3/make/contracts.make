echo "----- Contracts build started ----"

cd ../contracts

ocamlopt -for-pack CONTRACTS -c MODULE.ml
ocamlopt -for-pack CONTRACTS -c LEVEL_SOURCE.ml
ocamlopt -for-pack CONTRACTS -c DOTS_OF_DICE_NODE.ml
ocamlopt -for-pack CONTRACTS -c LEVELS_SOURCE_TREE.ml
ocamlopt -for-pack CONTRACTS -c PROTOIMAGE.ml
ocamlopt -for-pack CONTRACTS -c PROTOIMAGES_STORAGE.ml
ocamlopt -I ../../bin -for-pack CONTRACTS -c TISSUE_OBSERVER.ml
ocamlopt -I ../../bin -for-pack CONTRACTS -c BREADCRUMBS_OBSERVER.ml

ocamlopt -pack -o CONTRACTS.cmx \
MODULE.cmx LEVEL_SOURCE.cmx DOTS_OF_DICE_NODE.cmx \
LEVELS_SOURCE_TREE.cmx PROTOIMAGE.cmx PROTOIMAGES_STORAGE.cmx \
TISSUE_OBSERVER.cmx BREADCRUMBS_OBSERVER.cmx 

mv CONTRACTS.cmx ../../bin/CONTRACTS.cmx
mv CONTRACTS.cmi ../../bin/CONTRACTS.cmi
mv CONTRACTS.o ../../bin/CONTRACTS.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "---- Contracts build completed ---"
