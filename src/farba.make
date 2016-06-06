cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin "T'.ml" dotsOfDice.mli dotsOfDice.ml handSide.ml helsPigment.mli helsPigment.ml pigment.mli pigment.ml relationship.ml hexagonSide.mli hexagonSide.ml comparableInt.mli comparableInt.ml breadcrumbs.mli breadcrumbs.ml command.ml protocell.mli protocell.ml set.mli set.ml cellState.ml replicationResult.ml CELL.ml cell.mli cell.ml observableCell.mli observableCell.ml stepper.mli stepper.ml

echo "build complete"

