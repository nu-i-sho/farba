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
ocamlopt -for-pack Shared -c colony.mli
ocamlopt -for-pack Shared -c colony.ml
ocamlopt -for-pack Shared -c TISSUE.ml
ocamlopt -for-pack Shared -c dotsOfDice.mli 
ocamlopt -for-pack Shared -c dotsOfDice.ml
ocamlopt -for-pack Shared -c relationship.ml
ocamlopt -for-pack Shared -c BREADCRUMBS.ml
ocamlopt -for-pack Shared -c command.mli 
ocamlopt -for-pack Shared -c command.ml

ocamlopt -pack -o shared.cmx helsPigment.cmx pigment.cmx hand.cmx side.cmx cellKind.cmx protocell.cmx index.cmx int.cmx item.cmx colony.cmx TISSUE.cmx dotsOfDice.cmx relationship.cmx BREADCRUMBS.cmx command.cmx

mv shared.cmx ../../bin/shared.cmx
mv shared.cmi ../../bin/shared.cmi
mv shared.o ../../bin/shared.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Shared build complete"

#=============================================================

cd ../core

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c breadcrumbs.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c breadcrumbs.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c cell.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c cell.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissue.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissue.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c TISSUE_CELL.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissueCell.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c tissueCell.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c mode.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c program.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c program.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c virus.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -c virus.ml

ocamlopt -pack -o core.cmx breadcrumbs.cmx cell.cmx tissue.cmx TISSUE_CELL.cmx tissueCell.cmx mode.cmx program.cmx virus.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build complete"

#=============================================================
cd ../view/img/54x54/dots 

ocamlopt -for-pack View.Img._54x54_.DotsOfDice -c OOOOOO.ml
ocamlopt -for-pack View.Img._54x54_.DotsOfDice -c OOOOO.ml
ocamlopt -for-pack View.Img._54x54_.DotsOfDice -c OOOO.ml
ocamlopt -for-pack View.Img._54x54_.DotsOfDice -c OOO.ml
ocamlopt -for-pack View.Img._54x54_.DotsOfDice -c OO.ml
ocamlopt -for-pack View.Img._54x54_.DotsOfDice -c O.ml

ocamlopt -for-pack View.Img._54x54_ -pack -o dotsOfDice.cmx OOOOOO.cmx OOOOO.cmx OOOO.cmx OOO.cmx OO.cmx O.cmx

mv dotsOfDice.cmx ../dotsOfDice.cmx
mv dotsOfDice.cmi ../dotsOfDice.cmi
mv dotsOfDice.o ../dotsOfDice.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../acts

ocamlopt -for-pack View.Img._54x54_.Act -c turnLeft.ml
ocamlopt -for-pack View.Img._54x54_.Act -c turnRight.ml
ocamlopt -for-pack View.Img._54x54_.Act -c replicateDirect.ml
ocamlopt -for-pack View.Img._54x54_.Act -c replicateInverse.ml

ocamlopt -for-pack View.Img._54x54_ -pack -o act.cmx turnLeft.cmx turnRight.cmx replicateDirect.cmx replicateInverse.cmx 

mv act.cmx ../act.cmx
mv act.cmi ../act.cmi
mv act.o ../act.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -for-pack View.Img._54x54_ end.ml

ocamlopt -for-pack View.Img -pack -o _54x54_.cmx end.cmx act.cmx dotsOfDice.cmx

mv _54x54_.cmx ../_54x54_.cmx
mv _54x54_.cmi ../_54x54_.cmi
mv _54x54_.o ../_54x54_.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../20x20/dots

ocamlopt -for-pack View.Img._20x20_.DotsOfDice -c OOOOOO.ml
ocamlopt -for-pack View.Img._20x20_.DotsOfDice -c OOOOO.ml
ocamlopt -for-pack View.Img._20x20_.DotsOfDice -c OOOO.ml
ocamlopt -for-pack View.Img._20x20_.DotsOfDice -c OOO.ml
ocamlopt -for-pack View.Img._20x20_.DotsOfDice -c OO.ml
ocamlopt -for-pack View.Img._20x20_.DotsOfDice -c O.ml

ocamlopt -for-pack View.Img._20x20_ -pack -o dotsOfDice.cmx OOOOOO.cmx OOOOO.cmx OOOO.cmx OOO.cmx OO.cmx O.cmx

mv dotsOfDice.cmx ../dotsOfDice.cmx
mv dotsOfDice.cmi ../dotsOfDice.cmi
mv dotsOfDice.o ../dotsOfDice.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -for-pack View.Img -pack -o _20x20_.cmx dotsOfDice.cmx

mv _20x20_.cmx ../_20x20_.cmx
mv _20x20_.cmi ../_20x20_.cmi
mv _20x20_.o ../_20x20_.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -for-pack View -pack -o img.cmx _20x20_.cmx _54x54_.cmx

mv img.cmx ../img.cmx
mv img.cmi ../img.cmi
mv img.o ../img.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c const.ml
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
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c defaultColorSheme.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissuePrinter.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissuePrinter.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c window.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c window.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissue.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c tissue.ml
#ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c commandImg.mli
#ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -c commandImg.ml

ocamlopt -pack -o view.cmx img.cmx const.cmx pair.cmx point.cmx doublePoint.cmx line.cmx doubleLine.cmx floatPoint.cmx eyes.cmx TISSUE_SCALE.cmx tissueScale.cmx TISSUE_PRINTER.cmx canvas.cmx CANVAS.cmx TISSUE_COLOR_SHEME.cmx defaultColorSheme.cmx tissuePrinter.cmx window.cmx tissue.cmx #commandImg.cmx

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
