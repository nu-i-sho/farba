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

module MakePrintable (Printer : TISSUE_PRINTER.T) = struct
    type t' = t
    type t  = { storage : t';
                printer : Printer.t
              }

    let width  o = width o.storage
    let height o = height o.storage
    let get i  o = get i o.storage

    let set i v o = 
      let previous = get i o in
      let () = set i v o.storage in
      match previous, v with
	
      | Item.Empty, Item.Cytoplasm a   ->
         Printer.print_cyto i a o.printer
     
      | Item.Empty, Item.Cell a
      | Item.Cytoplasm _ , Item.Cell a -> 
	 Printer.print_cell i a o.printer

      | Item.Cell a, Item.Cell b       -> 
	 Printer.print_diff i 
		  ~previous:a 
		   ~current:b
		            o.printer

    let load path printer = 
      let o = { storage = load path; printer } in
      let () = for x = 0 to width o do
		 for y = 0 to height o do
		   Printer.print_empty (x, y) printer
		 done
	       done
      in
      o
end
