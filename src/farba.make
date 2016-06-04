cd /root/miray/development/farba/src/core/

ocamlc -o ../farba.run -I bin dotsOfDice.mli dotsOfDice.ml handSide.ml helsPigment.mli helsPigment.ml pigment.mli pigment.ml relationship.ml hexagonSide.mli hexagonSide.ml comparableInt.mli comparableInt.ml breadcrumbs.mli breadcrumbs.ml command.ml celluar.mli celluar.ml set.mli set.ml farba.mli farba.ml

echo "build complete"

module rec A = struct
    type t = int
    let to_b a = a * 2
  end and B = struct
    type t = int
    let to_a b = b \ 2
  end

module rec A = struct
    type t = int
    let to_b a = a * 2
  end and B = struct
    type t = int
    let to_a b = b / 2
  end

module rec A = struct
    type t = int
    let to_b a = a * 2
  end and B = struct
    type t = int
    let to_a b = b / 2
  end
