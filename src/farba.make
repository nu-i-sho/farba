#=============================================================

cd shared

ocamlopt -for-pack Shared -c helsPigment.mli 
ocamlopt -for-pack Shared -c helsPigment.ml  
ocamlopt -for-pack Shared -c pigment.mli 
ocamlopt -for-pack Shared -c pigment.ml
ocamlopt -for-pack Shared -c hand.ml
ocamlopt -for-pack Shared -c side.mli
ocamlopt -for-pack Shared -c side.ml
ocamlopt -for-pack Shared -c cellKind.ml
ocamlopt -for-pack Shared -c protocell.mli
ocamlopt -for-pack Shared -c protocell.ml
ocamlopt -for-pack Shared -c index.ml
ocamlopt -for-pack Shared -c int.mli
ocamlopt -for-pack Shared -c int.ml
ocamlopt -for-pack Shared -c item.ml
ocamlopt -for-pack Shared -c TISSUE.ml

ocamlopt -pack -o shared.cmx helsPigment.cmx pigment.cmx hand.cmx side.cmx cellKind.cmx protocell.cmx index.cmx int.cmx item.cmx TISSUE.cmx 

mv shared.cmx ../../bin/shared.cmx
mv shared.cmi ../../bin/shared.cmi
mv shared.o ../../bin/shared.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Shared build complete"

#=============================================================

cd ../core

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c dotsOfDice.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c dotsOfDice.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c relationship.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c breadcrumbs.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c breadcrumbs.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c command.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c command.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c cell.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c cell.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissue.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissue.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissueCell.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissueCell.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c mode.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c program.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c program.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c virus.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c virus.ml

ocamlopt -pack -o core.cmx dotsOfDice.cmx relationship.cmx breadcrumbs.cmx command.cmx cell.cmx tissue.cmx tissueCell.cmx mode.cmx program.cmx virus.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build complete"

#=============================================================

cd ../view

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c pair.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c point.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c doublePoint.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c line.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c doubleLine.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c floatPoint.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c eyes.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c TISSUE_SCALE.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissueScale.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissueScale.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c TISSUE_PRINTER.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c CANVAS.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c canvas.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c canvas.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c TISSUE_COLOR_SHEME.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissuePrinter.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissuePrinter.ml

ocamlopt -pack -o view.cmx pair.cmx point.cmx doublePoint.cmx line.cmx doubleLine.cmx floatPoint.cmx eyes.cmx TISSUE_SCALE.cmx tissueScale.cmx TISSUE_PRINTER.cmx canvas.cmx CANVAS.cmx TISSUE_COLOR_SHEME.cmx tissuePrinter.cmx

mv view.cmx ../../bin/view.cmx
mv view.cmi ../../bin/view.cmi
mv view.o ../../bin/view.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "View build complete"

#=============================================================

echo "build all complete"

#=============================================================
