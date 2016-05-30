cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dots.mli dots.ml crosses.ml handSide.ml side.mli side.ml gene.ml RNA.ml

echo "build complete"
