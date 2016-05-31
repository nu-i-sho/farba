let read_lines_from path =
  let rec read file = 
    try (input_line file) :: (read file)
    with End_of_file -> 
      let () = close_in file in 
      []
  in

  read (open_in path)

let read_from path =
  let lines  = read_lines_from path in
  let height = lines |> List.length in
  let width  = lines |> List.map String.length
                     |> List.fold_left max 0
  in

  (* for empty border *) 
  let height = height + 2 in
  let width = width + 2 in
  let grid = Array.make_matrix width height None 
  in
  
  let process_line y = 
    let process y x =
      function | ' ' -> () 
               | chr -> let pigment = Pigment.of_char chr in
                        let open Gene.OfFlesh in
                        let gene = Cytoplazm pigment in
                        let cytoplazm = 
			  gene |> DNA.Builder.make 
                               |> DNA.Builder.result in
                        grid.(x + 1).(y + 1) <- Some cytoplazm
    in

    String.iteri (process y)
  in

  let () = lines |> List.iteri process_line in
  grid
