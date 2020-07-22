#!/bin/zsh

package="API"

echo "$package build started"

source ./shared.zsh
cd ../$package
bin=../../bin

$cpp -c api.cpp -o $package.$clib
mv $package.$clib $bin/$package.$clib

echo "$package build completed"
