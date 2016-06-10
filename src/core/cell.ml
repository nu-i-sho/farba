type t = {  index : Index.t;
           tissue : Tissue.t
         }

let save cell o =
  Tissue.set o.index (Item.Cell cell) o.tissue 

let first tissue index =
  match Tissue.get index tissue with
  | Empty -> let o = { index; tissue } in
             let () = save Protocell.first o in
             Some o
  | _     -> None

let value_of { tissue; index; } =
  let Item.Cell v = Tissue.get index tissue in
  v

let kind_of o =
  Protocell.kind_of (value_of o)

let is_out o =
  (Tissue.get o.index o.tissue) == Item.Out

let turn side o =
  let cell  = value_of o in
  let cell' = Protocell.turn side cell in
  let () = save cell' o in
  o

let replicate relation o =
  let cell = value_of o in
  let i' = Index.move cell.gaze o.index in
  let o' = { o with index = i' } in
  let acceptor = Tissue.get i' o.tissue in
  let cell' = Protocell.replicate relation cell in
  let open Item in 
  let () = match acceptor with
           | Out         -> ()
           | Empty       -> save cell' o' 
           | Cytoplasm c -> save (Protocell.inject c cell') o'
           | Cell c      -> save (Protocell.to_clot cell') o'
  in 
  o'
