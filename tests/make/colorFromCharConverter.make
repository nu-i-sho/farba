cd "/root/Development/farba/src/"

echo "build sources for testing started" 

ocamlopt -c T.ml
ocamlopt -c color.ml
ocamlopt -c invalidArg.ml
ocamlopt -c CONVERTER.ml
ocamlopt CONVERTER.cmx -c FROM_CHAR_CONVERTER.ml
ocamlopt FROM_CHAR_CONVERTER.cmx -c COLOR_FROM_CHAR_CONVERTER.ml
ocamlopt invalidArg.cmx COLOR_FROM_CHAR_CONVERTER.cmx -c colorFromCharConverter.mli colorFromCharConverter.ml

echo "build sources for testing finished"

mv "T.cmx" "../bin/T.cmx"
mv "T.cmi" "../bin/T.cmi"
mv "T.o"   "../bin/T.o"
mv "color.cmx" "../bin/color.cmx"
mv "color.cmi" "../bin/color.cmi"
mv "color.o"   "../bin/color.o"
mv "invalidArg.cmx" "../bin/invalidArg.cmx"
mv "invalidArg.cmi" "../bin/invalidArg.cmi"
mv "invalidArg.o"   "../bin/invalidArg.o"
mv "CONVERTER.cmx" "../bin/CONVERTER.cmx"
mv "CONVERTER.cmi" "../bin/CONVERTER.cmi"
mv "CONVERTER.o"   "../bin/CONVERTER.o"
mv "FROM_CHAR_CONVERTER.cmx" "../bin/FROM_CHAR_CONVERTER.cmx"
mv "FROM_CHAR_CONVERTER.cmi" "../bin/FROM_CHAR_CONVERTER.cmi"
mv "FROM_CHAR_CONVERTER.o"   "../bin/FROM_CHAR_CONVERTER.o"
mv "COLOR_FROM_CHAR_CONVERTER.cmx" "../bin/COLOR_FROM_CHAR_CONVERTER.cmx"
mv "COLOR_FROM_CHAR_CONVERTER.cmi" "../bin/COLOR_FROM_CHAR_CONVERTER.cmi"
mv "COLOR_FROM_CHAR_CONVERTER.o"   "../bin/COLOR_FROM_CHAR_CONVERTER.o"
mv "colorFromCharConverter.cmx"    "../bin/colorFromCharConverter.cmx"
mv "colorFromCharConverter.cmi"    "../bin/colorFromCharConverter.cmi"
mv "colorFromCharConverter.o"      "../bin/colorFromCharConverter.o"

echo "builded files moved to bin"
echo "tests building started"

cd "../tests/src/color"

ocamlopt -I ../../lib -I ../../../bin unix.cmxa UnitO.cmx T.cmx color.cmx invalidArg.cmx CONVERTER.cmx FROM_CHAR_CONVERTER.cmx COLOR_FROM_CHAR_CONVERTER.cmx colorFromCharConverter.cmx -o colorFromCharConverterTestsRun.opt colorFromCharConverterTests.mli colorFromCharConverterTests.ml colorFromCharConverterTestsRun.ml

echo "tests building finished"

mv "colorFromCharConverterTests.cmx"    "../../bin/colorFromCharConverterTests.cmx"
mv "colorFromCharConverterTests.cmi"    "../../bin/colorFromCharConverterTests.cmi"
mv "colorFromCharConverterTests.o"      "../../bin/colorFromCharConverterTests.o" 
mv "colorFromCharConverterTestsRun.cmx" "../../bin/colorFromCharConverterTestsRun.cmx"
mv "colorFromCharConverterTestsRun.cmi" "../../bin/colorFromCharConverterTestsRun.cmi"
mv "colorFromCharConverterTestsRun.o"   "../../bin/colorFromCharConverterTestsRun.o" 
mv "colorFromCharConverterTestsRun.opt" "../../bin/colorFromCharConverterTestsRun.opt"

echo "builded files moved to bin"

cd "../../bin"
chmod u+x colorFromCharConverterTestsRun.opt
./colorFromCharConverterTestsRun.opt

echo "colorFromCharConverterTestsRun.opt completed"
