cd "/root/Development/farba/src/"

echo "build sources for testing started" 

ocamlopt -c T.ml
ocamlopt T.cmx -c EMPTIBLE.ml 
ocamlopt T.cmx -c MAKEABLE.ml 
ocamlopt MAKEABLE.cmx -c FROM_CHAR_MAKEABLE.ml
ocamlopt EMPTIBLE.cmx FROM_CHAR_MAKEABLE.cmx -c EMPTIBLE_AND_FROM_CHAR_MAKEABLE.ml
ocamlopt FROM_CHAR_MAKEABLE.cmx EMPTIBLE_AND_FROM_CHAR_MAKEABLE.cmx -c  cell.mli cell.ml 

echo "build sources for testing finished"

mv "T.cmx" "../bin/T.cmx"
mv "T.cmi" "../bin/T.cmi"
mv "T.o"   "../bin/T.o"
mv "EMPTIBLE.cmx" "../bin/EMPTIBLE.cmx"
mv "EMPTIBLE.cmi" "../bin/EMPTIBLE.cmi"
mv "EMPTIBLE.o"   "../bin/EMPTIBLE.o"
mv "MAKEABLE.cmx" "../bin/MAKEABLE.cmx"
mv "MAKEABLE.cmi" "../bin/MAKEABLE.cmi"
mv "MAKEABLE.o"   "../bin/MAKEABLE.o"
mv "FROM_CHAR_MAKEABLE.cmx" "../bin/FROM_CHAR_MAKEABLE.cmx" 
mv "FROM_CHAR_MAKEABLE.cmi" "../bin/FROM_CHAR_MAKEABLE.cmi"
mv "FROM_CHAR_MAKEABLE.o"   "../bin/FROM_CHAR_MAKEABLE.o"
mv "EMPTIBLE_AND_FROM_CHAR_MAKEABLE.cmx" "../bin/EMPTIBLE_AND_FROM_CHAR_MAKEABLE.cmx"  
mv "EMPTIBLE_AND_FROM_CHAR_MAKEABLE.cmi" "../bin/EMPTIBLE_AND_FROM_CHAR_MAKEABLE.cmi"
mv "EMPTIBLE_AND_FROM_CHAR_MAKEABLE.o"   "../bin/EMPTIBLE_AND_FROM_CHAR_MAKEABLE.o"
mv "cell.cmx" "../bin/cell.cmx" 
mv "cell.cmi" "../bin/cell.cmi"
mv "cell.o"   "../bin/cell.o"

echo "builded files moved to bin"
echo "tests building started"

cd "../tests/src/cell"

ocamlopt -I ../../lib -I ../../../bin UnitO.cmx T.cmx EMPTIBLE.cmx MAKEABLE.cmx FROM_CHAR_MAKEABLE.cmx EMPTIBLE_AND_FROM_CHAR_MAKEABLE.cmx cell.cmx -o cell.opt DUMMY_MAKEABLE.ml DummyMakeable.mli DummyMakeable.ml cellTests.mli cellTests.ml farbaTestsRun.ml

echo "tests building finished"

mv "DUMMY_MAKEABLE.cmx" "../../bin/DUMMY_MAKEABLE.cmx"
mv "DUMMY_MAKEABLE.cmi" "../../bin/DUMMY_MAKEABLE.cmi"
mv "DUMMY_MAKEABLE.o"   "../../bin/DUMMY_MAKEABLE.o" 
mv "DummyMakeable.cmx"  "../../bin/DummyMakeable.cmx"  
mv "DummyMakeable.cmi"  "../../bin/DummyMakeable.cmi"
mv "DummyMakeable.o"    "../../bin/DummyMakeable.o"
mv "cellTests.cmx"      "../../bin/cellTests.cmx" 
mv "cellTests.cmi"      "../../bin/cellTests.cmi"
mv "cellTests.o"        "../../bin/cellTests.o"
mv "farbaTestsRun.cmx"  "../../bin/farbaTestsRun.cmx"
mv "farbaTestsRun.cmi"  "../../bin/farbaTestsRun.cmi"
mv "farbaTestsRun.o"    "../../bin/farbaTestsRun.o"
mv "cell.opt"           "../../bin/cell.opt"

echo "builded files moved to bin"

cd "../../bin"
chmod u+x cell_tests.run
./cell_tests.run

echo "cell_tests.run completed"
