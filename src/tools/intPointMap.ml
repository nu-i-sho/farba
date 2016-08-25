include Map.Make (struct
		      type t = int * int
		      let compare (x_1, y_1) (x_2, y_2) =
			let by_x = compare x_1 x_2 in
			if by_x = 0 then
			  compare y_1 y_2 else
			  by_x
		   end)
let set i v o =
  add i v (if o |> mem i then
              o |> remove i else
	      o)
