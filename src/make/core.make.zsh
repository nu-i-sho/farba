#!/bin/zsh

source ./shared.zsh

module=Core
package=${module:l}

echo "$module build started"

cd ../$package
bin=../../bin

src_files=(
    list             mli ml
    map              mli ml
    seq              mli ml
    dots             mli ml
    hand                 ml
    gene                 ml
    nature               ml
    pigment          mli ml
    side             mli ml
    nucleus          mli ml
    tissue           mli ml
    energy           mli ml
    statement            ml
    source           mli ml
    tape             mli ml
    OBSERV               ml
    PACK                 ml
    subject          mli ml
    reObservable     mli ml
    config           mli ml
    oTissue          mli ml
    LEVEL                ml
    levels/level_001     ml
    levels/level_002     ml
    levels/level_003     ml
    levels/level_004     ml
    levels/level_005     ml
    levels/level_006     ml
    levels/level_007     ml
    levels/level_008     ml
    levels/level_009     ml
    levels           mli ml
    processor        mli ml
    backup           mli ml
    api              mli ml
)

for_pack=()
file=null
for f in $src_files
do
    if   [[ $f == "ml" || $f == "mli" ]]
    then $caml -I levels -for-pack $module -c $file.$f
    else file=$f
	 for_pack+=$file.$x
    fi
done

$caml -I $bin -pack -o $package.$x $for_pack[@]

rm_all_caml_bins $bin
mv_caml_bins $package $bin
mv_caml_bins $package/levels $bin
rm_all_caml_bins $(pwd)
rm_all_caml_bins $(pwd)/levels

echo "$module build completed"
