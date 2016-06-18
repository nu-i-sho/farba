#=============================================================

cd shared

ocamlc -for-pack Shared -g -c std.ml 
ocamlc -for-pack Shared -g -c helsPigment.mli 
ocamlc -for-pack Shared -g -c helsPigment.ml  
ocamlc -for-pack Shared -g -c pigment.mli 
ocamlc -for-pack Shared -g -c pigment.ml
ocamlc -for-pack Shared -g -c hand.ml
ocamlc -for-pack Shared -g -c side.mli
ocamlc -for-pack Shared -g -c side.ml
ocamlc -for-pack Shared -g -c cellKind.ml
ocamlc -for-pack Shared -g -c protocell.mli
ocamlc -for-pack Shared -g -c protocell.ml
ocamlc -for-pack Shared -g -c index.ml
ocamlc -for-pack Shared -g -c int.mli
ocamlc -for-pack Shared -g -c int.ml
ocamlc -for-pack Shared -g -c item.ml
ocamlc -for-pack Shared -g -c colony.mli
ocamlc -for-pack Shared -g -c colony.ml
ocamlc -for-pack Shared -g -c TISSUE.ml
ocamlc -for-pack Shared -g -c dotsOfDice.mli 
ocamlc -for-pack Shared -g -c dotsOfDice.ml
ocamlc -for-pack Shared -g -c relationship.ml
ocamlc -for-pack Shared -g -c BREADCRUMBS.ml
ocamlc -for-pack Shared -g -c command.mli 
ocamlc -for-pack Shared -g -c command.ml
ocamlc -for-pack Shared -g -c program.mli
ocamlc -for-pack Shared -g -c program.ml

ocamlc -pack -o shared.cmo std.cmo helsPigment.cmo pigment.cmo hand.cmo side.cmo cellKind.cmo protocell.cmo index.cmo int.cmo item.cmo colony.cmo TISSUE.cmo dotsOfDice.cmo relationship.cmo BREADCRUMBS.cmo command.cmo program.cmo

mv shared.cmo ../../dbg/shared.cmo
mv shared.cmi ../../dbg/shared.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

echo "Shared build complete"

#=============================================================

cd ../core

ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c breadcrumbs.mli 
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c breadcrumbs.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c cell.mli 
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c cell.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c tissue.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c tissue.ml 
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c TISSUE_CELL.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c tissueCell.mli 
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c tissueCell.ml 
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c mode.ml 
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c virus.mli 
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack Core -g -c virus.ml

ocamlc -pack -g -o core.cmo breadcrumbs.cmo cell.cmo tissue.cmo TISSUE_CELL.cmo tissueCell.cmo mode.cmo virus.cmo

mv core.cmo ../../dbg/core.cmo
mv core.cmi ../../dbg/core.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

echo "Core build complete"

#=============================================================
cd ../view/img/54x54/dots 

ocamlc -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOOOOO.ml
ocamlc -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOOOO.ml
ocamlc -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOOO.ml
ocamlc -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OOO.ml
ocamlc -for-pack View.ImgPrototype.X54.DotsOfDice -g -c OO.ml
ocamlc -for-pack View.ImgPrototype.X54.DotsOfDice -g -c O.ml

ocamlc -for-pack View.ImgPrototype.X54 -pack -g -o dotsOfDice.cmo OOOOOO.cmo OOOOO.cmo OOOO.cmo OOO.cmo OO.cmo O.cmo

mv dotsOfDice.cmo ../dotsOfDice.cmo
mv dotsOfDice.cmi ../dotsOfDice.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

#=============================================================
cd ../acts

ocamlc -for-pack View.ImgPrototype.X54.Act -g -c turnLeft.ml
ocamlc -for-pack View.ImgPrototype.X54.Act -g -c turnRight.ml
ocamlc -for-pack View.ImgPrototype.X54.Act -g -c replicateDirect.ml
ocamlc -for-pack View.ImgPrototype.X54.Act -g -c replicateInverse.ml

ocamlc -for-pack View.ImgPrototype.X54 -pack -g -o act.cmo turnLeft.cmo turnRight.cmo replicateDirect.cmo replicateInverse.cmo 

mv act.cmo ../act.cmo
mv act.cmi ../act.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

#=============================================================
cd ../

ocamlc -for-pack View.ImgPrototype.X54 end.ml

ocamlc -for-pack View.ImgPrototype -pack -g -o x54.cmo end.cmo act.cmo dotsOfDice.cmo

mv x54.cmo ../x54.cmo
mv x54.cmi ../x54.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

#=============================================================
cd ../20x20/dots

ocamlc -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOOOOO.ml
ocamlc -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOOOO.ml
ocamlc -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOOO.ml
ocamlc -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OOO.ml
ocamlc -for-pack View.ImgPrototype.X20.DotsOfDice -g -c OO.ml
ocamlc -for-pack View.ImgPrototype.X20.DotsOfDice -g -c O.ml

ocamlc -for-pack View.ImgPrototype.X20 -pack -g -o dotsOfDice.cmo OOOOOO.cmo OOOOO.cmo OOOO.cmo OOO.cmo OO.cmo O.cmo

mv dotsOfDice.cmo ../dotsOfDice.cmo
mv dotsOfDice.cmi ../dotsOfDice.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

#=============================================================
cd ../

ocamlc -for-pack View.ImgPrototype -pack -g -o x20.cmo dotsOfDice.cmo

mv x20.cmo ../x20.cmo
mv x20.cmi ../x20.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

#=============================================================
cd ../

ocamlc -for-pack View -pack -g -o imgPrototype.cmo x20.cmo x54.cmo

mv imgPrototype.cmo ../imgPrototype.cmo
mv imgPrototype.cmi ../imgPrototype.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

#=============================================================
cd ../

ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c IMG_PROTOTYPE.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c IMG.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c img.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c img.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c const.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c pair.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c point.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c doublePoint.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c line.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c doubleLine.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c floatPoint.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c eyes.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c TISSUE_SCALE.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c tissueScale.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c tissueScale.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c TISSUE_PRINTER.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c CANVAS.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c canvas.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c canvas.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c TISSUE_COLOR_SHEME.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c defaultColorSheme.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c tissuePrinter.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c tissuePrinter.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c window.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c window.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c tissue.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c tissue.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c PROGRAM_POINTER.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c programPrinter.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c programPrinter.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c programPointer.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c programPointer.ml
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c breadcrumbs.mli
ocamlc -I ../../dbg shared.cmo -open Shared -for-pack View -g -c breadcrumbs.ml

ocamlc -pack -g -o view.cmo IMG_PROTOTYPE.cmo IMG.cmo imgPrototype.cmo img.cmo const.cmo pair.cmo point.cmo doublePoint.cmo line.cmo doubleLine.cmo floatPoint.cmo eyes.cmo TISSUE_SCALE.cmo tissueScale.cmo TISSUE_PRINTER.cmo canvas.cmo CANVAS.cmo TISSUE_COLOR_SHEME.cmo defaultColorSheme.cmo tissuePrinter.cmo window.cmo tissue.cmo PROGRAM_POINTER.cmo programPrinter.cmo programPointer.cmo breadcrumbs.cmo

mv view.cmo ../../dbg/view.cmo
mv view.cmi ../../dbg/view.cmi

find . -type f -iname \*.cmo -delete
find . -type f -iname \*.cmi -delete

echo "View build complete"

#=============================================================
cd ../main

ocamlc -thread unix.cma graphics.cma threads.cma -I ../../dbg shared.cmo view.cmo core.cmo -open Shared -g -o farba_dbg.run main.ml
chmod +t farba_dbg.run
./farba_dbg.run
#=============================================================

echo "build all complete"

#=============================================================
