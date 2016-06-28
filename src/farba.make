echo "------ Shared build started ------"

cd shared

ocamlopt -c data.ml

mv data.cmx ../../bin/data.cmx
mv data.cmi ../../bin/data.cmi
mv data.o ../../bin/data.o

echo "----- Shared build completed -----"
echo "------- Core build started -------"

cd ../core

ocamlopt -I ../../bin data.cmx -for-pack Core -c pigment.mli 
ocamlopt -I ../../bin data.cmx -for-pack Core -c pigment.ml
ocamlopt -for-pack Core -c hand.ml

ocamlopt -pack -o core.cmx pigment.cmx hand.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Core build completed ------"

