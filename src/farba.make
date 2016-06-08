cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml handSide.ml helsPigment.mli helsPigment.ml pigment.mli pigment.ml relationship.ml hexagonSide.mli hexagonSide.ml breadcrumbs.mli breadcrumbs.ml command.ml cellKind.ml protocell.mli protocell.ml set.mli set.ml cell.mli cell.ml mode.ml virus.mli virus.ml

echo "build complete"

