cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml handSide.ml pigment.mli pigment.ml relationship.ml hexagonSide.mli hexagonSide.ml lifeMode.ml comparableInt.mli comparableInt.ml breadcrumbs.mli breadcrumbs.ml command.ml virus.mli virus.ml cytoplazm.mli cytoplazm.ml nucleus.mli nucleus.ml celluar.mli celluar.ml  procaryote.ml eucaryote.mli eucaryote.ml flesh.mli flesh.ml creature.ml set.mli set.ml hexagon.mli hexagon.ml

echo "build complete"
