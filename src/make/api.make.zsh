#!/bin/zsh

package="api"

echo "$package build started"

source ./shared.zsh
cd ../$package
bin=../../bin

$caml  -I $bin -output-obj -o api.$o \
       unix.cmxa core.$x api.ml

mv api.$o $bin/api.$o
rm_all_caml_bins $(pwd)

$cpp -I $camlpath -L $camlpath -I .. \
     $bin/api.$o $bin/𝚊𝚙𝚒.$clib \
     subject.cpp api.cpp \
     -o $package.$clib -lunix -lasmrun
     
mv $package.$clib $bin/$package.$clib

echo "$package build completed"
