type 'a t = 'a * 'a

val map  : ('a -> 'b) -> 'a t -> 'b t
val iter : ('a -> unit) -> 'a t -> unit
val sum  : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
val fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
