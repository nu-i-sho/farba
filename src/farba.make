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
ocamlopt -I ../../bin data.cmx -for-pack Core -c side.mli 
ocamlopt -I ../../bin data.cmx -for-pack Core -c side.ml
ocamlopt -I ../../bin data.cmx -for-pack Core -c nucleus.mli 
ocamlopt -I ../../bin data.cmx -for-pack Core -c nucleus.ml
ocamlopt -for-pack Core -c COLONY.ml
ocamlopt -for-pack Core -c colony.mli 
ocamlopt -for-pack Core -c colony.ml
ocamlopt -for-pack Core -c borderedColony.mli 
ocamlopt -I ../../bin data.cmx -for-pack Core -c borderedColony.ml
ocamlopt -for-pack Core -c colonyCounter.mli
ocamlopt -I ../../bin data.cmx -for-pack Core -c colonyCounter.ml
ocamlopt -for-pack Core -c index.mli 
ocamlopt -I ../../bin data.cmx -for-pack Core -c index.ml
ocamlopt -for-pack Core -c tissue.mli
ocamlopt -for-pack Core -c tissue.ml
ocamlopt -I ../../bin data.cmx -for-pack Core -c activeCell.mli
ocamlopt -I ../../bin data.cmx -for-pack Core -c activeCell.ml

ocamlopt -pack -o core.cmx pigment.cmx hand.cmx nucleus.cmx COLONY.cmx colony.cmx borderedColony.cmx colonyCounter.cmx index.cmx tissue.cmx activeCell.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "------ Core build completed ------"

