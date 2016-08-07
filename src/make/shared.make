echo "------ Shared build started ------"

cd ../shared

ocamlopt -c data.ml
ocamlopt -c T.ml

mv *.cmx ../../bin/
mv *.cmi ../../bin/
mv *.o ../../bin/

echo "----- Shared build completed -----"
