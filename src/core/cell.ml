type t = { index : Set.Index.t;
             set : Set.t
         }

let save cell o =
  Set.set o.index (Set.Value.Cell cell) o.set 

let first set index =
  match Set.get index set with
  | Empty -> let o = { index; set } in
             let () = save Protocell.first o in
             Some o
  | _     -> None

let value_of { set; index; } =
  let Set.Value.Cell v = Set.get index set in
  v

let kind_of o =
  Protocell.kind_of (value_of o)

let is_out o =
  (Set.get o.index o.set) == Set.Value.Out

let turn side o =
  let cell  = value_of o in
  let cell' = Protocell.turn side cell in
  let () = save cell' o in
  o

let replicate relation o =
  let cell = value_of o in
  let i' = Set.Index.move cell.gaze o.index in
  let o' = { o with index = i' } in
  let acceptor = Set.get i' o.set in
  let cell' = Protocell.replicate relation cell in
  let open Set.Value in 
  let () = match acceptor with
           | Out         -> ()
           | Empty       -> save cell' o' 
           | Cytoplasm c -> save (Protocell.inject c cell') o'
           | Cell c      -> save (Protocell.to_clot cell') o'
  in 
  o'
