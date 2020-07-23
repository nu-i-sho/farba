#!/bin/zsh

package="api"

echo "$package build started"

source ./shared.zsh
cd ../$package
bin=../../bin

$caml  -I $bin -output-obj -o api.$o \
       unix.cmxa core.$x api.ml

#rm_all_caml_bins $bin
mv api.$o $bin/api.$o
rm_all_caml_bins $(pwd)

$cpp -I $camlpath -L $camlpath -I ../𝚊𝚙𝚒 \
     $bin/api.$o $bin/𝚊𝚙𝚒.$clib \
     api.cpp -o $package.$clib -lunix -lasmrun
     
mv $package.$clib $bin/$package.$clib

echo "$package build completed"
