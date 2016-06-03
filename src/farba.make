cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml handSide.ml helsPigment.mli helsPigment.ml pigment.mli pigment.ml relationship.ml hexagonSide.mli hexagonSide.ml lifeMode.ml comparableInt.mli comparableInt.ml breadcrumbs.mli breadcrumbs.ml command.ml celluar.mli celluar.ml flesh.mli flesh.ml set.mli set.ml hexagon.mli hexagon.ml

echo "build complete"
