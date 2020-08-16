type 'a t = unit -> 'a node
 and 'a node = | (::) of 'a * 'a t
               |  []

let rec fold_left f acc o =
  match o () with
  | h :: t -> fold_left f (f acc h) t
  | []     -> acc
