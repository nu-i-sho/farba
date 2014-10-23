(* cartridge examples

let cartridge =
  [|"<1>.<3>.<5>.<5>..";
    "..<4>.<->.<0>.<5>";
    "<2>.<1>.<0>.<4>..";
    "..<2>.<1>.<->.<0>";
    "<2>.<1>.<0>.[-].."|]

let cartridge' =
  [|"........<1>......";
    "......<->.<0>....";
    "....<1>.<0>.<4>..";
    "..<2>.<1>.<->.<0>";
    "....<1>.[-].<4>..";
    "......<3>.<5>....";
    "........<->......";
    "......<0>........";
    "..<2>.<1>.<->.<0>";
    "....<1>.<0>.<4>.."|]

*)

include Matrix.Make(struct
  type t = Cell.t
  let empty = Cell.None
end)

let parce' make_matrix cartridge =
  let cartridge_hight = cartridge |> List.length   in
  let cartridge_width = cartridge |> List.hd 
                                  |> String.length in
  let matrix = 
    make_matrix cartridge_hight ((cartridge_width - 2) / 4)
  in
  let i, j = ref 0, ref 0 in
  let read_next () =
    if !i = cartridge_hight
    then '@'                      (* end      *)
    else if !j = cartridge_width
    then let () = j := 0 in 
         '#'                      (* end line *)
    else let k = !j in
         let () = j := !j + 1 in
	 cartridge.(!i).[!j]
  in
  let g i j v = 
    set matrix ((i - 1) / 2, j / 2) v
  in
  let open Cell in
  let rec parce'' i j = function
    | '.', 0 -> f 0 (i + 1) j 
    | '<', 0 -> f 1 (i + 1) j
    | chr, 1 -> let () = g i j (Expected (Color.of_char chr))
             in f 2 (i + 1) j
    | '>', 2 -> f 0 (i + 1) j
    | '[', 0 -> f 3 (i + 1) j
    | chr, 3 -> let () = g i j (Farba (Color.of_char chr)) 
             in f 4 (i + 1) j
    | ']', 4 -> f 0 (i + 1) j
    | '#', 0 -> f 0 i (j + 1)
    | '@', 0 -> ()
  (*| _      -> failwith "Parse error (this should be impossible)"*)

  and f s i j = parce'' (read_next (), s) i j in 
  let () = f 0 0 0 in
  matrix

let parse = 
  parse' make

let parse_o cartridge ~observer = 
  parse' (make_o ~observer) cartridge

