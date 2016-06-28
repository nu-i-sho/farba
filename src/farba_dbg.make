echo "------ Shared build started ------"

cd shared

ocamlc -c data.ml

mv data.cmo ../../bin/data.cmo
mv data.cmi ../../bin/data.cmi

echo "----- Shared build completed -----"
echo "------- Core build started -------"

cd ../core

ocamlc -I ../../bin data.cmo -for-pack Core -c pigment.mli 
ocamlc -I ../../bin data.cmo -for-pack Core -c pigment.ml
ocamlc -for-pack Core -c hand.ml
ocamlc -I ../../bin data.cmo -for-pack Core -c side.mli 
ocamlc -I ../../bin data.cmo -for-pack Core -c side.ml


ocamlc -pack -o core.cmo pigment.cmo hand.cmo side.cmo

mv core.cmo ../../bin/core.cmo
mv core.cmi ../../bin/core.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

echo "------ Core build completed ------"

