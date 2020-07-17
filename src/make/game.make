echo "Game build started"

./core.make

cd ../game

ocamlopt -I ../../bin/ -open Core -for-pack Game -c \
level_001.ml \
level_002.ml \
level_003.ml \
level_004.ml \
level_005.ml \
level_006.ml \
level_007.ml \
level_008.ml \
level_009.ml \
level_009.ml \
levels.mli \
levels.ml \
config.mli \
config.ml \
program.mli \
program.ml 

ocamlopt -pack -o game.cmx \
../../bin/core.cmx level_001.cmx level_002.cmx level_003.cmx level_004.cmx \
level_005.cmx level_006.cmx level_007.cmx level_008.cmx level_009.cmx \
levels.cmx config.cmx program.cmx

mv game.cmx ../../bin/game.cmx
mv game.cmi ../../bin/game.cmi
mv game.o ../../bin/game.o

ocamlopt -output-obj -o game.o unix.cmxa ../../bin/game.cmx

mv game.o ../../bin/game.o 

rm ../../bin/core.cmx
rm ../../bin/core.cmi
rm ../../bin/core.o

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete

echo "Game build completed"
