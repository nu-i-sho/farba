cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dots.mli dots.ml crosses.ml handSide.ml hexSide.mli hexSide.ml pigment.mli pigment.ml relationship.ml gene.ml RNA.ml

echo "build complete"
