include module type of Seq

val append   : 'a t -> 'a t -> 'a t 
val skip     : 'a -> 'a t -> 'a t
val skip_opt : 'a -> 'a t -> 'a t option
