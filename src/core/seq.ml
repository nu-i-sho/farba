include Seq

let append a b =
  let rec f next () = 
    match next () with
    | Cons (x, next) -> Cons (x, (f next))
    | Nil            -> b () in
  f a

let skip_opt x o =
    match o () with
  | Seq.Cons (x', next) when x' = x -> Some next
  | Seq.Cons _ | Seq.Nil            -> None
  
let skip x o =
  match skip_opt x o with
  | Some next -> next
  | None      -> assert false
