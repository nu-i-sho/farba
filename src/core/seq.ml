include Seq

let append a b =
  let rec f next () = 
    match next () with
    | Cons (x, next) -> Cons (x, (f next))
    | Nil            -> b () in
  f a
