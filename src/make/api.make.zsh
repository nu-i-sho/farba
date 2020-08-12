#!/bin/zsh

package="api"

echo "$package build started"

source ./shared.zsh
cd ../$package
bin=../../bin

$caml  -I $bin -output-obj -o CAMLapi.$o \
       unix.cmxa core.$x api.ml

rm_all_caml_bins $bin
mv CAMLapi.$o $bin/CAMLapi.$o
rm_all_caml_bins $(pwd)

$cpp -I .. -c subject.cpp
$cpp -I $camlpath -I .. -c caml.cpp
$cpp -I $camlpath -I .. -c core.cpp
$cpp -I $camlpath -I .. -c api.cpp
$cpp -I $camlpath -L $camlpath -I .. \
     $bin/CAMLapi.$o subject.o caml.o core.o api.o \
     -o $package.$clib -lunix -lasmrun #-lm -ldl
     
mv $package.$clib $bin/$package.$clib
rm_all_c_bins $(pwd)
rm $bin/CAMLapi.$o

echo "$package build completed"
