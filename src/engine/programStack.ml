type t = ProgramLine.t list

let push line o = line :: o
let top = List.hd
let pop = List.tl
