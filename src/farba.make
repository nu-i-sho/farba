cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml crosses.ml handSide.ml hexagonSide.mli hexagonSide.ml pigment.mli pigment.ml relationship.ml gene.ml RNA.ml DNA.ml hexagon.mli hexagon.ml levelReader.mli levelReader.ml

echo "build complete"
