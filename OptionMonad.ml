type 'a t = 'a option;;

let bind opt f =
  match opt with
  | Some x -> f x
  | None   -> None

let return x = Some x
