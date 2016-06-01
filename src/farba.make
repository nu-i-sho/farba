cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml handSide.ml pigment.mli pigment.ml relationship.ml hexagonSide.mli hexagonSide.ml runMode.ml gene.ml RNA.mli RNA.ml DNA.mli DNA.ml set.mli set.ml hexagon.mli hexagon.ml

echo "build complete"
