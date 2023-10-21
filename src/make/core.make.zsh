#!/bin/zsh

caml=ocamlopt
x=cmx
i=cmi
o=o

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


echo "$core build started"

module=Core
package=${module:l}

cd ../$package
bin=../../bin

src_files=(
    hand           ml
    gene           ml
    command        ml
    SEQUENTIAL     ml
    dots       mli ml
    direction      ml
    energy     mli ml
)

for_pack=()
file=null
for f in $src_files
do
    if   [[ $f == "ml" || $f == "mli" ]]
    then $caml -for-pack $module -c $file.$f
    else file=$f
	 for_pack+=$file.$x
    fi
done

$caml -I $bin -pack -o $package.$x $for_pack[@]

rm_all_caml_bins $bin
mv_caml_bins $package $bin
rm_all_caml_bins $(pwd)

echo "$core build completed"
