#!/bin/zsh

package="𝚊𝚙𝚒"

echo "$package build started"

source ./shared.zsh
cd ../$package
bin=../../bin

$cpp -c 𝚊𝚙𝚒.cpp -o $package.$clib
mv $package.$clib $bin/$package.$clib

echo "$package build completed"
