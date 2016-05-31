cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml handSide.ml pigment.mli pigment.ml relationship.ml hexagonSide.ml hexagonSide.mli gene.ml RNA.ml DNA.ml hexagon.mli hexagon.ml levelReader.mli levelReader.ml

echo "build complete"
