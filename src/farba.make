#=============================================================

cd shared

ocamlopt -for-pack Shared -g -c std.ml 
ocamlopt -for-pack Shared -g -c helsPigment.mli 
ocamlopt -for-pack Shared -g -c helsPigment.ml  
ocamlopt -for-pack Shared -g -c pigment.mli 
ocamlopt -for-pack Shared -g -c pigment.ml
ocamlopt -for-pack Shared -g -c hand.ml
ocamlopt -for-pack Shared -g -c side.mli
ocamlopt -for-pack Shared -g -c side.ml
ocamlopt -for-pack Shared -g -c cellKind.ml
ocamlopt -for-pack Shared -g -c protocell.mli
ocamlopt -for-pack Shared -g -c protocell.ml
ocamlopt -for-pack Shared -g -c index.ml
ocamlopt -for-pack Shared -g -c int.mli
ocamlopt -for-pack Shared -g -c int.ml
ocamlopt -for-pack Shared -g -c item.ml
ocamlopt -for-pack Shared -g -c colony.mli
ocamlopt -for-pack Shared -g -c colony.ml
ocamlopt -for-pack Shared -g -c TISSUE.ml
ocamlopt -for-pack Shared -g -c dotsOfDice.mli 
ocamlopt -for-pack Shared -g -c dotsOfDice.ml
ocamlopt -for-pack Shared -g -c relationship.ml
ocamlopt -for-pack Shared -g -c BREADCRUMBS.ml
ocamlopt -for-pack Shared -g -c command.mli 
ocamlopt -for-pack Shared -g -c command.ml
ocamlopt -for-pack Shared -g -c program.mli
ocamlopt -for-pack Shared -g -c program.ml

ocamlopt -pack -o shared.cmx std.cmx helsPigment.cmx pigment.cmx hand.cmx side.cmx cellKind.cmx protocell.cmx index.cmx int.cmx item.cmx colony.cmx TISSUE.cmx dotsOfDice.cmx relationship.cmx BREADCRUMBS.cmx command.cmx program.cmx

mv shared.cmx ../../bin/shared.cmx
mv shared.cmi ../../bin/shared.cmi
mv shared.o ../../bin/shared.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Shared build complete"

#=============================================================

cd ../core

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c breadcrumbs.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c breadcrumbs.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c cell.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c cell.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c tissue.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c tissue.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c TISSUE_CELL.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c tissueCell.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c tissueCell.ml 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c mode.ml
ocamlopt -for-pack Core -g -c lifeCounter.mli
ocamlopt -for-pack Core -g -c lifeCounter.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c runtime.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c runtime.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c virus.mli 
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack Core -g -c virus.ml

ocamlopt -pack -g -o core.cmx breadcrumbs.cmx cell.cmx tissue.cmx TISSUE_CELL.cmx tissueCell.cmx mode.cmx lifeCounter.cmx runtime.cmx virus.cmx

mv core.cmx ../../bin/core.cmx
mv core.cmi ../../bin/core.cmi
mv core.o ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Core build complete"

#=============================================================
cd ../view/img/54x54/dots 

ocamlopt -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOOOOO.ml
ocamlopt -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOOOO.ml
ocamlopt -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOOO.ml
ocamlopt -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOO.ml
ocamlopt -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OO.ml
ocamlopt -for-pack View.ImgPrototype.X54.DotsOfDice -g -c O.ml

ocamlopt -for-pack View.ImgPrototype.X54 -pack -g -o dotsOfDice.cmx OOOOOO.cmx OOOOO.cmx OOOO.cmx OOO.cmx OO.cmx O.cmx

mv dotsOfDice.cmx ../dotsOfDice.cmx
mv dotsOfDice.cmi ../dotsOfDice.cmi
mv dotsOfDice.o ../dotsOfDice.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../acts

ocamlopt -for-pack View.ImgPrototype.X54.Act -g -c turnLeft.ml
ocamlopt -for-pack View.ImgPrototype.X54.Act -g -c turnRight.ml
ocamlopt -for-pack View.ImgPrototype.X54.Act -g -c replicateDirect.ml
ocamlopt -for-pack View.ImgPrototype.X54.Act -g -c replicateInverse.ml

ocamlopt -for-pack View.ImgPrototype.X54 -pack -g -o act.cmx turnLeft.cmx turnRight.cmx replicateDirect.cmx replicateInverse.cmx 

mv act.cmx ../act.cmx
mv act.cmi ../act.cmi
mv act.o ../act.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -for-pack View.ImgPrototype.X54 end.ml

ocamlopt -for-pack View.ImgPrototype -pack -g -o x54.cmx end.cmx act.cmx dotsOfDice.cmx

mv x54.cmx ../x54.cmx
mv x54.cmi ../x54.cmi
mv x54.o ../x54.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../20x20/dots

ocamlopt -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOOOOO.ml
ocamlopt -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOOOO.ml
ocamlopt -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOOO.ml
ocamlopt -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOO.ml
ocamlopt -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OO.ml
ocamlopt -for-pack View.ImgPrototype.X20.DotsOfDice -g -c O.ml

ocamlopt -for-pack View.ImgPrototype.X20 -pack -g -o dotsOfDice.cmx OOOOOO.cmx OOOOO.cmx OOOO.cmx OOO.cmx OO.cmx O.cmx

mv dotsOfDice.cmx ../dotsOfDice.cmx
mv dotsOfDice.cmi ../dotsOfDice.cmi
mv dotsOfDice.o ../dotsOfDice.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -for-pack View.ImgPrototype -pack -g -o x20.cmx dotsOfDice.cmx

mv x20.cmx ../x20.cmx
mv x20.cmi ../x20.cmi
mv x20.o ../x20.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -for-pack View -pack -g -o imgPrototype.cmx x20.cmx x54.cmx

mv imgPrototype.cmx ../imgPrototype.cmx
mv imgPrototype.cmi ../imgPrototype.cmi
mv imgPrototype.o ../imgPrototype.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#=============================================================
cd ../

ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c IMG_PROTOTYPE.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c IMG.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c img.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c img.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c const.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c pair.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c point.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c doublePoint.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c line.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c doubleLine.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c floatPoint.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c eyes.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c TISSUE_SCALE.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c tissueScale.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c tissueScale.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c TISSUE_PRINTER.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c CANVAS.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c canvas.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c canvas.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c TISSUE_COLOR_SHEME.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c defaultColorSheme.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c tissuePrinter.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c tissuePrinter.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c tissue.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c tissue.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c PROGRAM_POINTER.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c programPrinter.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c programPrinter.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c programPointer.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c programPointer.ml
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c breadcrumbs.mli
ocamlopt -I ../../bin shared.cmx -open Shared -for-pack View -g -c breadcrumbs.ml

ocamlopt -pack -g -o view.cmx IMG_PROTOTYPE.cmx IMG.cmx imgPrototype.cmx img.cmx const.cmx pair.cmx point.cmx doublePoint.cmx line.cmx doubleLine.cmx floatPoint.cmx eyes.cmx TISSUE_SCALE.cmx tissueScale.cmx TISSUE_PRINTER.cmx CANVAS.cmx canvas.cmx TISSUE_COLOR_SHEME.cmx defaultColorSheme.cmx tissuePrinter.cmx tissue.cmx PROGRAM_POINTER.cmx programPrinter.cmx programPointer.cmx breadcrumbs.cmx

mv view.cmx ../../bin/view.cmx
mv view.cmi ../../bin/view.cmi
mv view.o ../../bin/view.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "View build complete"

#=============================================================
cd ../main

ocamlopt -thread unix.cmxa graphics.cmxa threads.cmxa -I ../../bin shared.cmx view.cmx core.cmx -open Shared -g -o farba.run main.ml
chmod +t farba.run
./farba.run
#=============================================================

echo "build all complete"

#=============================================================
