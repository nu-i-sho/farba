type 'a t

val empty    : int -> int -> 'a -> 'a t
val of_array : 'a array array -> 'a t
val of_map   : int -> int -> 'a -> 'a Index.Map.t -> 'a t
val optional : int -> int -> 'a Index.Map.t -> 'a option t
val height   : 'a t -> int
val width    : 'a t -> int
val get      : (int * int) -> 'a t -> 'a
val set      : (int * int) -> 'a -> 'a t -> 'a t
val in_range : (int * int) -> 'a t -> bool
val is_out   : (int * int) -> 'a t -> bool
val map      : ('a -> 'b) -> 'a t -> 'b t
val mapi     : ((int * int) -> 'a -> 'b) -> 'a t -> 'b t
val map2     : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
val zip      : 'a t -> 'b t -> ('a * 'b) t
val iter     : ('a -> unit) -> 'a t -> unit
val iteri    : ((int * int) -> 'a -> unit) -> 'a t -> unit
val index    : ('a -> bool) -> 'a t -> (int * int) option
val fold     : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
val foldi    : ('a -> (int * int) -> 'b -> 'a) -> 'a -> 'b t -> 'a

val of_string_array : string array -> char t
val of_string_list  : string list  -> char t
