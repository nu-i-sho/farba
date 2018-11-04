type t = { cursor : Tissue.Coord.t;
             tape : Tape.t
         }

let make tape cursor =
  { cursor;
    tape
  }

let cursor o = o.cursor
let tape o = o.tape
