caml=ocamlopt
x="cmx"
i="cmi"
o="o"

mv_all_bins () { # $1 bin folder
    for f in *
    do
	if [[ ${f:e} == $x || ${f:e} == $i || ${f:e} == $o ]]
	then mv $f $1/$f
	fi
    done
}

clear_bins () { # $1 bin folder
    jumpback=$(pwd)
    cd $1
    
    find . -type f -iname \*.$x -delete
    find . -type f -iname \*.$i -delete
    find . -type f -iname \*.$o -delete

    cd $jumpback
}

mv_bins () {
    # $1 - package name
    # $2 - bin directory

    mv $1.$x $2/$1.$x
    mv $1.$i $2/$1.$i
    mv $1.$o $2/$1.$o
}

rm_bins () {
    # $1 - package name
    # $2 - bin directory

    rm $2/$1.$x
    rm $2/$1.$i
    rm $2/$1.$o
}

rm_tmp_bins () {
    find . -type f -iname \*.$x -delete
    find . -type f -iname \*.$i -delete
    find . -type f -iname \*.$o -delete
}

