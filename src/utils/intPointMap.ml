include MapExt.Make (struct type t = int * int
                            let compare (x_1, y_1) (x_2, y_2) =
			      let by_x = compare x_1 x_2 in
			      if by_x = 0 then
			        compare y_1 y_2 else
			        by_x
          	       end)

let parse parse_velue str =
  let rec parse i str_buff x_buff y_buff acc =
    match str.[i], str_buff, x_buff, y_buff with

    | '(',  _, _, _
    | ',', "", None, None
      -> parse (succ i) "" None None acc

    | ',', _, None, _
      -> let x = int_of_string str_buff in
         parse (succ i) "" (Some x) None acc

    | ',', _, _, None
      -> let y = int_of_string str_buff in
         parse (succ i) "" x_buff (Some y) acc

    | ')', _, (Some x), (Some y)
      -> let value = parse_velue str_buff in
         parse (succ i) "" None None (add (x, y) value acc)

    | chr, _, _, _
      -> let str_buff = str_buff ^ (Char.escaped chr) in
         parse (succ i) str_buff x_buff y_buff acc

  in parse 0 "" None None empty
