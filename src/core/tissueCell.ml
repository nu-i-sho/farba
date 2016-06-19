module Make (Tissue : TISSUE.T) = struct
    
    type t = {  index : Index.t;
               tissue : Tissue.t
             }

    let activate cell o =
      Tissue.set o.index (Item.ActiveCell cell) o.tissue 

    let deactivate o =
      let Item.ActiveCell c = Tissue.get o.index o.tissue in
      Tissue.set o.index (Item.Cell c) o.tissue

    let make tissue index =
      match Tissue.get index tissue with
      | Item.Empty -> let o = {index; tissue } in
		      let () = activate Cell.first o in
		      Some o
      | _          -> None

    let value_of { tissue; index; } =
      let Item.ActiveCell v | Item.Cell v = 
	Tissue.get index tissue 
      in
      v

    let kind_of o =
      Cell.kind_of (value_of o)

    let is_out o =
      (Tissue.get o.index o.tissue) == Item.Out

    let turn side o =
      let cell  = value_of o in
      let cell' = Cell.turn side cell in
      let () = activate cell' o in
      o

    let move (x, y) ~side:s = 
      Side.( match (x mod 2), s with

	     | 0, Up        -> (x    , y - 1)
             | 0, LeftUp    -> (x - 1, y    )
             | 0, RightUp   -> (x + 1, y    )
             | 0, Down      -> (x    , y + 1) 
             | 0, LeftDown  -> (x - 1, y + 1)
             | 0, RightDown -> (x + 1, y + 1)  

             | 1, Up        -> (x    , y - 1)  
             | 1, LeftUp    -> (x - 1, y - 1)
             | 1, RightUp   -> (x + 1, y - 1)
             | 1, Down      -> (x    , y + 1)
             | 1, LeftDown  -> (x - 1, y    )
             | 1, RightDown -> (x + 1, y    ))

    let replicate relation o =
      let cell = value_of o in
      let i' = move o.index ~side:cell.gaze in
      let o' = { o with index = i' } in
      let acceptor = Tissue.get i' o.tissue in
      let cell' = Cell.replicate relation cell in
      let open Item in 
      let () = deactivate o in
      let () = 
	match acceptor with
        | Out         -> ()
        | Empty       -> activate cell' o' 
        | Cytoplasm c -> activate (Cell.inject c cell') o'
        | Cell c      -> activate (Cell.to_clot cell') o'
      in 
      o'
  end
