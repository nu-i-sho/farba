echo "------ Shared build started ------"

cd shared

ocamlc -c data.ml

mv data.cmo ../../bin/data.cmo
mv data.cmi ../../bin/data.cmi

ocamlc -I ../../bin data.cmo -c T.ml

mv T.cmo ../../bin/T.cmo
mv T.cmi ../../bin/T.cmi

echo "----- Shared build completed -----"
echo "------- Core build started -------"

cd ../core

ocamlc -I ../../bin data.cmo -for-pack Core -c pigment.mli 
ocamlc -I ../../bin data.cmo -for-pack Core -c pigment.ml
ocamlc -for-pack Core -c hand.ml
ocamlc -I ../../bin data.cmo -for-pack Core -c side.mli
ocamlc -I ../../bin data.cmo -for-pack Core -c side.ml
ocamlc -I ../../bin data.cmo -for-pack Core -c nucleus.mli
ocamlc -I ../../bin data.cmo -for-pack Core -c nucleus.ml
ocamlc -for-pack Core -c COLONY.ml
ocamlc -for-pack Core -c colony.mli
ocamlc -for-pack Core -c colony.ml
ocamlc -for-pack Core -c borderedColony.mli
ocamlc -I ../../bin data.cmo -for-pack Core -c borderedColony.ml
ocamlc -for-pack Core -c colonyCounter.mli
ocamlc -I ../../bin data.cmo -for-pack Core -c colonyCounter.ml
ocamlc -for-pack Core -c index.mli
ocamlc -I ../../bin data.cmo -for-pack Core -c index.ml
ocamlc -for-pack Core -c TISSUE.ml
ocamlc -for-pack Core -c tissue.mli
ocamlc -for-pack Core -c tissue.ml
ocamlc -for-pack Core -c ANATOMY.ml
ocamlc -for-pack Core -c anatomy.mli
ocamlc -for-pack Core -c anatomy.ml
ocamlc -for-pack Core -c anatomyCounter.mli
ocamlc -I ../../bin data.cmo -for-pack Core -c anatomyCounter.ml
ocamlc -I ../../bin data.cmo -for-pack Core -c ACTIVE_CELL.ml
ocamlc -I ../../bin data.cmo -for-pack Core -c activeCell.mli
ocamlc -I ../../bin data.cmo -for-pack Core -c activeCell.ml

ocamlc -pack -o core.cmo pigment.cmo hand.cmo side.cmo nucleus.cmo COLONY.cmo colony.cmo borderedColony.cmo colonyCounter.cmo index.cmo TISSUE.cmo tissue.cmo ANATOMY.cmo anatomy.cmo anatomyCounter.cmo ACTIVE_CELL.cmo activeCell.cmo

mv core.cmo ../../bin/core.cmo
mv core.cmi ../../bin/core.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

echo "------ Core build completed ------"

