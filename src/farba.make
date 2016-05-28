cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin point.ml turning_gene.ml replication_gene.ml acting_gene.ml marking_gene.ml flash_gene.ml mutagene.ml

echo "build complete"
