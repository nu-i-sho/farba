module Index = struct
    type t = int * int

    let zero = (0, 0)

    let move side (x, y) =
      let open HexagonSide in
      match side with
      | Up        -> (x    , y - 1)
      | LeftUp    -> (x - 1, y - 1)
      | RightUp   -> (x + 1, y - 1)
      | Down      -> (x    , y + 1)
      | LeftDown  -> (x - 1, y    )
      | RightDown -> (x + 1, y    )
  end

module Value = struct
    type t = | Cytoplazm of HelsPigment.t
             | Celluar of Celluar.t
             | Empty		      
  end

module rec Element = struct 

    type t = { value : Value.t;
               index : Index.t;
                 set : Set.t
             }

    let neighbor side o = 
      let index' = HexagonSide.move o.index in
      if Set.is_in_range index' o then
	Some (Set.get index' o.set) else
	None

    let turn side o = 
      let (Value.Celluar cell) = o.value in 
      let cell' = Celluar.turn side cell in
      let value = Value.Celluar cell' in
      Set.set value o.set
      	     
    type replication_result_t = 
      | ReplicatedToOutOfWorld
      | Replicated of t
      | SelfCloted of t

    let replicate ~relationship:r ~donor:o =
      let (Value.Celluar c) = o.value in
      let acceptor = neighbor c.gaze in

      match acceptor with
      | None   -> ReplicatedToOutOfWorld
      | Some e -> 
	 let open Value in
	 let set_to hexagon c = 
	   Set.set hexagon.index (Celluar c') hexagon.set
	 in

	 match e.value with
	 | Empty -> 
	    let c' = Celluar.replicate
		       ~relationship:r 
                              ~donor:c 
	    in

	    Replicted (set_to e c')
	 | Cytoplazm c' ->
	    let c' = Celluar.replicate_to_cytoplazm 
		       ~relationship:r 
		              ~donor:o
		           ~acceptor:c'
	    in

	    Replicted (set_to e c')
	 | Celluar c' -> 
	    let c, c' = Celluar.replicate_to_celluar
			  ~relationship:r 
		                 ~donor:o
		              ~acceptor:c'
	    in

	    let open Celluar.Kind in
	    match Celluar.kind_of c with
	    | Cancer | Hels -> Replicated (set_to e c')
	    | Clot          -> SelfCloted (set_to o c)
	    
  end and Set = struct
 
    type t = Value.t array array

    let width = Array.length
    let height s = Array.length s.(0)

    let is_out_of_range (x, y) s = x < 0 
                                && y < 0 
                                && x >= (width s)
                                && y >= (height s)
    let get (x, y) s = 
      Element.({ index = x, y;
                 value = s.(x).(y);
	           set = s
	       })

    let set (x, y) v s =
	let () = s.(x).(y) <- v in
	get (x, y) s

    let is_in_range (x, y) s = x >= 0 
                            && y >= 0 
                            && x < (width s)
		            && y > (height s)

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
	    Value.Cytoplazm (HelsPigment.of_char chr) 
      in      
      
      String.iteri process_char

    let read path =
  
      let str_lines = read_linesm (open_in path) in
      let height, width = size_of str_lines in 
      let height, width = height + 2, width + 2 
      in

      let set = Array.make_matrix width height Value.Empty in
      let process_line = process_line_for set in
      let () = List.iteri process_line str_lines 
      in
      
      set
  end
