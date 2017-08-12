type 'a t
   
val make       : (int -> 'a) -> int -> 'a t
val length     : 'a t -> int
val item       : int -> 'a t -> 'a
val maybe_item : int -> 'a t -> 'a option
