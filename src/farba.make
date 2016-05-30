cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dots.mli dots.ml crosses.ml side.mli side.ml pigmentation.ml gene.ml RNA.ml

echo "build complete"
