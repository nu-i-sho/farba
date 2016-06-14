module Item = struct
    type t = | Cytoplasm of HelsPigment.t
             | Empty

    let to_tissue_item =
      function | Cytoplasm c -> Item.Cytoplasm c
               | Empty       -> Item.Empty

    let of_char = 
      function | ' ' -> Empty
               | chr -> Cytoplasm (HelsPigment.of_char chr)
  end

type t = Item.t array array

let width = Array.length
let height o = Array.length o.(0)
let get (x, y) o = o.(x).(y)
	    
let size_of lines =      
  (lines |> List.length),
  (lines |> List.map String.length
         |> List.fold_left max 0)

let load src = 
  let height, width = size_of src in 
  let empty_row () = 
    Array.make (width + 2) Item.Empty
  in

  let parse_cell_in src i = 
    if i = 0 || i = (width + 1) then
      Item.Empty else
      Item.of_char src.[i - 1]
  in 

  let parse_row src = 
    Array.init (width + 2) (parse_cell_in src) 
  in

  let rec parse rows i = 
    match i, rows with
    | 0, _        -> (empty_row ()) :: (parse rows (i + 1))
    | _, hd :: [] -> (parse_row hd) :: [empty_row ()]
    | _, hd :: tl -> (parse_row hd) :: (parse tl (i + 1))
  in

  Array.of_list (parse src 0)

let rec read_lines file = 
  try (input_line file) :: (read_lines file)
  with End_of_file -> 
    let () = close_in file in
    []

let read path = 
  load (read_lines (open_in path))
