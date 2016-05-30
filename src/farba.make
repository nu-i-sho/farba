cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dots.mli dots.ml kind.ml crosses.ml pigmentation.ml state.ml gene.ml RNA.ml

echo "build complete"
