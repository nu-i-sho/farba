type 'a t = unit -> 'a node
 and 'a node = | (::) of 'a * 'a t
               |  []

val fold_left : ('acc -> 'a -> 'acc) -> 'acc -> 'a t -> 'acc
