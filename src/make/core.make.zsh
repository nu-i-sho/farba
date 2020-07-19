#!/bin/zsh

caml=ocamlopt
x="cmx"
i="cmi"
o="o"

module=Core
package=${module:l}

echo "$module build started"

cd ../$package
bin=../../bin

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

src_files=(
    list          mli ml
    map           mli ml
    dots          mli ml
    hand              ml
    gene              ml
    nature            ml
    pigment       mli ml
    side          mli ml
    nucleus       mli ml
    command           ml
    tissue        mli ml
    cursor        mli ml
    energy        mli ml
    statement         ml
    source        mli ml
    tape          mli ml
    processor     mli ml
    OBSERV            ml
    subject       mli ml
)

bins=()
file=null
for f in $src_files
do
    if   [[ $f == "ml" || $f == "mli" ]]
    then $caml -for-pack $module -c $file.$f
    else file=$f
	 bins+=$file.$x
    fi
done

levels_module=Levels
levels_package=${levels_module:l}

echo "$levels_module build started"

cd $levels_package
prev_bin=$bin
bin="../$prev_bin"

levels_bins=()
for level in *
do
    if   [[ ${level:e} == "ml" ]]
    then $caml -I .. -for-pack $module.$levels_module -c $level
	 levels_bins+=${leve:r}.$x
    fi
done

$caml -pack -for-pack $module -o $levels_package.$x $level_bins[@]
mv_bins $levels_package $bin
rm_tmp_bins

bin=$prev_bin
bins+=$bin/$levels_package.$x
cd ..

echo "$levels_module build completed"

$caml -pack -o $package.$x $bins[@]

rm_bins $levels_package $bin
mv_bins $package $bin
rm_tmp_bins

$caml -output-obj -o $package.$o unix.cmxa $bin/$package.$x

rm_bins $package $bin
mv $package.$o $bin/$package.$o

echo "$module build completed"
