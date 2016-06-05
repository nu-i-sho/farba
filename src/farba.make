cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml handSide.ml helsPigment.mli helsPigment.ml pigment.mli pigment.ml relationship.ml hexagonSide.mli hexagonSide.ml comparableInt.mli comparableInt.ml breadcrumbs.mli breadcrumbs.ml command.ml CELL.ml protocell.mli protocell.ml set.mli set.ml cell.mli cell.ml stepper.mli stepper.ml

echo "build complete"

