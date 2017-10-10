type ('a, 'b) t = 'a * 'b

val make : 'a -> 'b -> ('a, 'b) t
val map  : ('a -> 'b) -> ('a, 'a) t -> ('b, 'b) t

