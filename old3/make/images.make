echo "------ Images build started ------"

cd ../images/54x54/dots 

ocamlopt -for-pack ImagePrototype.X54.DotsOfDice -c OOOOOO.ml
ocamlopt -for-pack ImagePrototype.X54.DotsOfDice -c OOOOO.ml
ocamlopt -for-pack ImagePrototype.X54.DotsOfDice -c OOOO.ml
ocamlopt -for-pack ImagePrototype.X54.DotsOfDice -c OOO.ml
ocamlopt -for-pack ImagePrototype.X54.DotsOfDice -c OO.ml
ocamlopt -for-pack ImagePrototype.X54.DotsOfDice -c O.ml

ocamlopt -for-pack ImagePrototype.X54 -pack -o dotsOfDice.cmx \
OOOOOO.cmx OOOOO.cmx OOOO.cmx OOO.cmx OO.cmx O.cmx

mv dotsOfDice.cmx ../dotsOfDice.cmx
mv dotsOfDice.cmi ../dotsOfDice.cmi
mv dotsOfDice.o ../dotsOfDice.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#                           *****

cd ../acts

ocamlopt -for-pack ImagePrototype.X54.Act -c turnLeft.ml
ocamlopt -for-pack ImagePrototype.X54.Act -c turnRight.ml
ocamlopt -for-pack ImagePrototype.X54.Act -c replicateDirect.ml
ocamlopt -for-pack ImagePrototype.X54.Act -c replicateInverse.ml

ocamlopt -for-pack ImagePrototype.X54 -pack -o act.cmx \
turnLeft.cmx turnRight.cmx replicateDirect.cmx replicateInverse.cmx 

mv act.cmx ../act.cmx
mv act.cmi ../act.cmi
mv act.o ../act.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#                           *****

cd ../

ocamlopt -for-pack ImagePrototype.X54 end.ml

ocamlopt -for-pack ImagePrototype -pack -o x54.cmx \
end.cmx act.cmx dotsOfDice.cmx

mv x54.cmx ../x54.cmx
mv x54.cmi ../x54.cmi
mv x54.o ../x54.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#                           *****

cd ../20x20/dots

ocamlopt -for-pack ImagePrototype.X20.DotsOfDice -c OOOOOO.ml
ocamlopt -for-pack ImagePrototype.X20.DotsOfDice -c OOOOO.ml
ocamlopt -for-pack ImagePrototype.X20.DotsOfDice -c OOOO.ml
ocamlopt -for-pack ImagePrototype.X20.DotsOfDice -c OOO.ml
ocamlopt -for-pack ImagePrototype.X20.DotsOfDice -c OO.ml
ocamlopt -for-pack ImagePrototype.X20.DotsOfDice -c O.ml

ocamlopt -for-pack ImagePrototype.X20 -pack -o dotsOfDice.cmx \
OOOOOO.cmx OOOOO.cmx OOOO.cmx OOO.cmx OO.cmx O.cmx

mv dotsOfDice.cmx ../dotsOfDice.cmx
mv dotsOfDice.cmi ../dotsOfDice.cmi
mv dotsOfDice.o ../dotsOfDice.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#                           *****

cd ../

ocamlopt -for-pack ImagePrototype -pack -o x20.cmx dotsOfDice.cmx

mv x20.cmx ../x20.cmx
mv x20.cmi ../x20.cmi
mv x20.o ../x20.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

#                           *****

cd ../

ocamlopt -pack -o imagePrototype.cmx x20.cmx x54.cmx

mv imagePrototype.cmx ../../bin/imagePrototype.cmx
mv imagePrototype.cmi ../../bin/imagePrototype.cmi
mv imagePrototype.o ../../bin/imagePrototype.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "----- Images build completed -----"
