type 'a t

val make           : 'a -> 'a t
val value          : 'a t -> 'a
val with_value     : 'a -> 'a t -> 'a t
val swap_to_run    : 'a t -> 'a t
val swap_to_scroll : 'a t -> 'a t
