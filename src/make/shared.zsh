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

rm_all_bins () { # $1 bin folder
    jumpback=$(pwd)
    cd $1
    
    find . -type f -iname \*.$x -delete
    find . -type f -iname \*.$i -delete
    find . -type f -iname \*.$o -delete

    cd $jumpback
}

