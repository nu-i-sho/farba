type t = Flesh.t option array array

let read_lines path =
  let rec read file = 
    try (input_line file) :: (read file)
    with End_of_file -> 
      let () = close_in file in 
      []
  in

  read (open_in path)

let read path =
  let lines  = read_lines path in
  let height = lines |> List.length in
  let width  = lines |> List.map String.length
                     |> List.fold_left max 0
  in

  (* for empty border *) 
  let height = height + 2 in
  let width = width + 2 in
  let set = Array.make_matrix width height None 
  in
  
  let process_line y =
    let open Flesh in
    let process y x =
      function | ' ' -> () 
               | chr -> let pigment = Pigment.of_char chr in
			let c = Cytoplazm.make pigment in
			let c = Procaryote.Cytoplazm c in
                        let c = Flesh.Procaryotic c in
                        set.(x + 1).(y + 1) <- Some c
    in

    String.iteri (process y)
  in

  let () = lines |> List.iteri process_line in
  set
