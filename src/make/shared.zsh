#!/bin/zsh

caml=ocamlopt
cpp=(g++ -std=c++17)

x=cmx
i=cmi
o=o
clib=so

camlpath=$(ocamlopt -where)

mv_all_caml_bins () { # $1 = bin folder
    for f in *
    do
	if [[ ${f:e} == $x || ${f:e} == $i || ${f:e} == $o ]]
	then mv $f $1/$f
	fi
    done
}

mv_caml_bins () {  # $1 = name, $2 = bin folder
    files=($1.$i $1.$x $1.$o)
    for file in $files
    do
	if [[ -f $file ]]
	then
	    mv $file $2/$file
	fi
    done
}

rm_all_caml_bins () { # $1 = in folder
    jumpback=$(pwd)
    cd $1
    
    find . -type f -iname \*.$x -delete
    find . -type f -iname \*.$i -delete
    find . -type f -iname \*.$o -delete

    cd $jumpback
}

rm_all_c_bins () { # $1 = in folder
    jumpback=$(pwd)
    cd $1
    
    find . -type f -iname \*.$o -delete
    find . -type f -iname \*.$clib -delete

    cd $jumpback
}
