cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin points.mli points.ml kind.ml graduation.ml gene.ml RNA.ml

echo "build complete"
