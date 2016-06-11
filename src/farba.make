cd shared

ocamlopt -for-pack Shared -c helsPigment.mli 
ocamlopt -for-pack Shared -c helsPigment.ml  
ocamlopt -for-pack Shared -c pigment.mli 
ocamlopt -for-pack Shared -c pigment.ml
ocamlopt -for-pack Shared -c hand.ml
ocamlopt -for-pack Shared -c side.mli
ocamlopt -for-pack Shared -c side.ml
ocamlopt -for-pack Shared -c protocell.ml
ocamlopt -for-pack Shared -c index.ml
ocamlopt -for-pack Shared -c PRINTER.ml

ocamlopt -pack -o shared.cmx helsPigment.cmx pigment.cmx hand.cmx side.cmx protocell.cmx index.cmx PRINTER.cmx

mv shared.cmx ../../bin/shared.cmx
mv shared.cmi ../../bin/shared.cmi
mv shared.o ../../bin/shared.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#echo "Shared build complete"

cd ../core

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c dotsOfDice.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c dotsOfDice.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c relationship.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c int.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c breadcrumbs.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c breadcrumbs.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c command.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c command.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c cellKind.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c protocell.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c protocell.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c item.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c index.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c index.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c TISSUE.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissue.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissue.ml 
ocamlopt -I ../../bin shared.cmx -for-pack Core -c cell.mli 
ocamlopt -I ../../bin shared.cmx -for-pack Core -c cell.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c mode.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c program.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c program.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c virus.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c virus.ml

ocamlopt -pack -o core.cmx dotsOfDice.cmx relationship.cmx int.cmx breadcrumbs.cmx command.cmx cellKind.cmx protocell.cmx item.cmx index.cmx TISSUE.cmx tissue.cmx cell.cmx mode.cmx program.cmx virus.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#echo "Core build complete"

cd ../view

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c hexagon.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c hexagon.ml

ocamlopt -pack -o view.cmx hexagon.cmx

mv view.cmx ../../bin/view.cmx
mv view.cmi ../../bin/view.cmi
mv view.o ../../bin/view.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#echo "View build complete"
#echo "build all complete"

