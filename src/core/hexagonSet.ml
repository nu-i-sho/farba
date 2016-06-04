module Index = struct
    type t = int * int

    let zero = (0, 0)

    let move side (x, y) =
      match side with
      | Up        -> (x    , y - 1)
      | LeftUp    -> (x - 1, y - 1)
      | RightUp   -> (x + 1, y - 1)
      | Down      -> (x    , y + 1)
      | LeftDown  -> (x - 1, y    )
      | RightDown -> (x + 1, y    )
  end

type element_t = Flesh.t option
type t = element_t array array;

let width = Array.length
let height s = Array.length s.(0)

let is_in_range (x, y) s = x >= 0 
                        && y >= 0 
			&& x < (width s)
			&& y > (height s)

let get (x, y) s = 
  if is_in_range (x, y) s then 
    Some s.(x).(y) else
    None

let set (x, y) v s = 
  if is_in_range (x, y) s then
    let s.(x).(y) <- v in true else
    false

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
  String.iteri 
    ( fun x chr -> 
      if chr == ' ' then () else
	let pigment = HelsPigment.of_char chr in
	let cytoplazm = Flesh.Cytoplazm pigment in
	set.(x + 1).(y + 1) <- Some
    )

let read path =
  
  let str_lines = read_linesm (open_in path) in
  let height, width = size_of str_lines in 
  let height, width = height + 2, width + 2 
  in

  let set = Array.make_matrix width height None in
  let process_line = process_line_for set in
  let () = List.iteri process_line str_lines 
  in
      
  set
