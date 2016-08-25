type 'a t
   
val make   : (int -> 'a) -> int -> 'a t
val length : 'a t -> int
val get    : int -> 'a t -> 'a

