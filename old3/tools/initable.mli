type ('a, 'b) t

val make   : 'a -> ('a, 'b) t
val made   : ('a, 'b) t -> 'a
val init   : 'b -> ('a, 'b) t
val inited : ('a, 'b) t -> 'b
