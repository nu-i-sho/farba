cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml hand.ml helsPigment.mli helsPigment.ml pigment.mli pigment.ml relationship.ml int.ml breadcrumbs.mli breadcrumbs.ml command.mli command.ml cellKind.ml hexagonSide.mli hexagonSide.ml protocell.mli protocell.ml hexagon.mli hexagon.ml cell.mli cell.ml mode.ml program.mli program.ml virus.mli virus.ml

echo "build complete"

