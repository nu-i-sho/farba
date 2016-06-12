type t = {  index : Index.t;
           tissue : Tissue.t
         }

let save cell o =
  Tissue.set o.index (Item.Cell cell) o.tissue 

let first tissue index =
  match Tissue.get index tissue with
  | Empty -> let o = { index; tissue } in
             let () = save Cell.first o in
             Some o
  | _     -> None

let value_of { tissue; index; } =
  let Item.Cell v = Tissue.get index tissue in
  v

let kind_of o =
  Cell.kind_of (value_of o)

let is_out o =
  (Tissue.get o.index o.tissue) == Item.Out

let turn side o =
  let cell  = value_of o in
  let cell' = Cell.turn side cell in
  let () = save cell' o in
  o

let move (x, y) ~side:s = 
  Side.( match s with
         | Up        -> (x    , y - 1)
         | LeftUp    -> (x - 1, y - 1)
         | RightUp   -> (x + 1, y - 1)
         | Down      -> (x    , y + 1)
         | LeftDown  -> (x - 1, y    )
         | RightDown -> (x + 1, y    )) 

let replicate relation o =
  let cell = value_of o in
  let i' = move o.index ~side:cell.gaze in
  let o' = { o with index = i' } in
  let acceptor = Tissue.get i' o.tissue in
  let cell' = Cell.replicate relation cell in
  let open Item in 
  let () = match acceptor with
           | Out         -> ()
           | Empty       -> save cell' o' 
           | Cytoplasm c -> save (Cell.inject c cell') o'
           | Cell c      -> save (Cell.to_clot cell') o'
  in 
  o'
