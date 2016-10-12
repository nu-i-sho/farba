include MapExt.Make (struct type t = int
                            let compare = compare
                       end)
          
let parse parse_velue str =
  let rec parse i str_buff key_buff acc =
    match str.[i], str_buff, key_buff with

    | '(',  _, _
    | ',', "", None
      -> parse (succ i) "" None acc

    | ',', _, None
      -> let key = int_of_string str_buff in
         parse (succ i) "" (Some key) acc

    | ')', _, (Some key)
      -> let value = parse_velue str_buff in
         parse (succ i) "" None (add key value acc)

    | chr, _, _
      -> let str_buff = str_buff ^ (Char.escaped chr) in
         parse (succ i) str_buff key_buff acc

  in parse 0 "" None empty 
