echo "View build started"

CAML=`ocamlopt -where`
BIN="../../bin"
PRODUCT="farba.game"

cd ../view

g++ -I $CAML -L $CAML $BIN/game.o \
program.cpp main.cpp -o $PRODUCT -lunix -lasmrun

mv $PRODUCT $BIN/$PRODUCT
chmod a+x $BIN/$PRODUCT

echo "View build completed"
