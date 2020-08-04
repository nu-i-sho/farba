#!/bin/zsh

package="𝚊𝚙𝚒"

echo "$package build started"

source ./shared.zsh
cd ../$package
bin=../../bin

$cpp -c 𝚘𝚋𝚜𝚎𝚛𝚟𝚊𝚝𝚒𝚘𝚗.cpp 
$cpp -I .. -c 𝚊𝚙𝚒.cpp
$cpp 𝚘𝚋𝚜𝚎𝚛𝚟𝚊𝚝𝚒𝚘𝚗.$o 𝚊𝚙𝚒.$o -shared -o $package.$clib #-lunix -lasmrun

mv $package.$clib $bin/$package.$clib
rm_all_c_bins $(pwd)

echo "$package build completed"
