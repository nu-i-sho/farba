type t = Item.t array array

let width = Array.length
let height o = Array.length o.(0)

let is_out (x, y) o = x < 0 && y < 0 
                            && 
             x >= (width o) && y >= (height o)

let get (x, y) o = 
  if is_out (x, y) o then
    Item.Out else
    o.(x).(y)

let set (x, y) v o = 
  o.(x).(y) <- v

let rec read_lines file = 
  try (input_line file) :: (read_lines file)
  with End_of_file -> 
    let () = close_in file in
    []
	    
let size_of lines =      
  (lines |> List.length),
  (lines |> List.map String.length
         |> List.fold_left max 0)

let process_line_for tissue y =
  let process_char x chr = 
    if chr == ' ' then () else
      tissue.(x + 1).(y + 1) <- 
	Item.Cytoplasm (HelsPigment.of_char chr) 
  in      
      
  String.iteri process_char

let load path =
  
  let str_lines = read_lines (open_in path) in
  let height, width = size_of str_lines in 
  let height, width = height + 2, width + 2 
  in

  let tissue = Array.make_matrix width height Item.Empty in
  let process_line = process_line_for tissue in
  let () = List.iteri process_line str_lines 
  in  
  
  tissue
