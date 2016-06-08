module Index = struct
    type t = int * int

    let zero = (0, 0)
    let move side (x, y) =
      Side.( match side with
             | Up        -> (x    , y - 1)
             | LeftUp    -> (x - 1, y - 1)
             | RightUp   -> (x + 1, y - 1)
             | Down      -> (x    , y + 1)
             | LeftDown  -> (x - 1, y    )
             | RightDown -> (x + 1, y    ))
  end

module Item = struct
    type t = | Cytoplasm of HelsPigment.t
             | Cell of Protocell.t
             | Empty
             | Out
end

module Set = struct
    type t = Item.t array array

    let width = Array.length
    let height s = Array.length s.(0)

    let is_out (x, y) s = x < 0 && y < 0 
                                && 
                 x >= (width s) && y >= (height s)

    let get (x, y) s = 
      if is_out (x, y) s then
	Item.Out else
	s.(x).(y)

    let set (x, y) v s = 
      s.(x).(y) <- v

    let rec read_lines file = 
      try (input_line file) :: (read_lines file)
      with End_of_file -> 
	let () = close_in file in
	[]
	    
    let size_of lines =      
      (lines |> List.length),
      (lines |> List.map String.length
             |> List.fold_left max 0)

    let process_line_for set y =
      let process_char x chr = 
	if chr == ' ' then () else
	  set.(x + 1).(y + 1) <- 
	    Item.Cytoplasm (HelsPigment.of_char chr) 
      in      
      
      String.iteri process_char

    let read path =
  
      let str_lines = read_lines (open_in path) in
      let height, width = size_of str_lines in 
      let height, width = height + 2, width + 2 
      in

      let set = Array.make_matrix width height Item.Empty in
      let process_line = process_line_for set in
      let () = List.iteri process_line str_lines 
      in
      
      set
  end
