#!/bin/zsh

source ./shared.zsh

module=Core
package=${module:l}

echo "$module build started"

cd ../$package
bin=../../bin

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
    CURSOR            ml
    cursor        mli ml
    energy        mli ml
    statement         ml
    source        mli ml
    tape          mli ml
    OBSERV            ml
    PACK              ml
    PROCESSOR         ml
    API               ml
    processor     mli ml
    subject       mli ml
    reObservable  mli ml
    oCursor       mli ml
    oProcessor    mli ml
    config        mli ml
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

mv_all_caml_bins $bin

echo "Levels build started"

cd levels
prev_bin=$bin
bin="../$prev_bin"

levels_for_pack=()
levels_code_lines=()
for level in *
do
    if   [[ ${level:e} == "ml" ]]
    then $caml -I $bin -for-pack $module.StdLevels -c $level
	 levels_for_pack+=${level:r}.$x
	 levels_code_lines+="    ${(C)level:r}.build_tissue;"
    fi
done

mv_all_caml_bins $bin
$caml -I $bin -pack -for-pack $module -o stdLevels.$x $levels_for_pack[@]
mv_all_caml_bins $bin

cd ..
bin=$prev_bin

./../make/inject.py "levels.ml" "levels" $levels_code_lines[@]
$caml -I $bin -for-pack $module -c levels.mli levels.ml
mv_all_caml_bins $bin

for_pack+=stdLevels.$x
for_pack+=levels.$x

echo "Levels build completed"

$caml -I $bin -for-pack $module -c api.mli api.ml
$caml -I $bin -for-pack $module -c oApi.mli oApi.ml
for_pack+=api.$x
for_pack+=oApi.$x

$caml -I $bin -pack -o $package.$x $for_pack[@]
rm_all_caml_bins $bin
mv_caml_bins $package $bin
rm_all_caml_bins $(pwd)

echo "$module build completed"
