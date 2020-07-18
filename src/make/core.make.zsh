module=Core

echo "$module build started"

cd ../core

bin="../../bin"
package=${module:l}
compiler="ocamlopt"
x="cmx"
i="cmi"
o="o"
compile="$compiler -for-pack $module -c"

$compile list.mli
$compile list.ml 
$compile map.mli
$compile map.ml
$compile dots.mli
$compile dots.ml
$compile hand.ml
$compile gene.ml
$compile nature.ml
$compile pigment.mli
$compile pigment.ml
$compile side.mli
$compile side.ml
$compile nucleus.mli
$compile nucleus.ml
$compile command.ml
$compile tissue.mli
$compile tissue.ml
$compile cursor.mli
$compile cursor.ml
$compile energy.mli
$compile energy.ml
$compile statement.ml
$compile source.mli
$compile source.ml
$compile tape.mli
$compile tape.ml
$compile processor.mli
$compile processor.ml
$compile OBSERV.ml
$compile subject.mli
$compile subject.ml

$compile level_001.ml
$compile level_002.ml
$compile level_003.ml
$compile level_004.ml
$compile level_005.ml
$compile level_006.ml
$compile level_007.ml
$compile level_008.ml
$compile level_009.ml
$compile level_009.ml
$compile levels.mli
$compile levels.ml
$compile config.mli
$compile config.ml
$compile program.mli
$compile program.ml

$compiler -pack -o $package.$x \
list.$x map.$x dots.$x hand.$x gene.$x nature.$x \
pigment.$x side.$x nucleus.$x command.$x tissue.$x cursor.$x energy.$x \
source.$x statement.$x tape.$x processor.$x OBSERV.$x subject.$x \
level_001.$x level_002.$x level_003.$x level_004.$x \
level_005.$x level_006.$x level_007.$x level_008.$x level_009.$x \
levels.$x config.$x program.$x

mv $package.$x $bin/$package.$x
mv $package.$i $bin/$package.$i
mv $package.$o $bin/$package.$o

find . -type f -iname \*.$x -delete
find . -type f -iname \*.$i -delete
find . -type f -iname \*.$o -delete

$compiler -output-obj -o $package.$o unix.cmxa $bin/$package.$x

rm $bin/$package.$x
rm $bin/$package.$i
rm $bin/$package.$o

mv $package.$o $bin/$package.$o

echo "$module build completed"
