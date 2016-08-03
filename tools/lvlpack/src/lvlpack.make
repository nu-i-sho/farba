ocamlopt unix.cmxa -o lvlpack.run lvlpack.mli lvlpack.ml main.ml

mv lvlpack.run ../bin/lvlpack.run

find . -type f -iname \*.cmx -delete
find . -type f -iname \*.cmi -delete
find . -type f -iname \*.o   -delete
