open Common
open Utils

type t

val empty : t
val length   : t -> int
val commands : t -> command list
val args     : t -> command Dots.Map.t IntMap.t
val loops    : t -> Dots.t IntMap.t
  
val remove_item    : int -> t -> t
val insert_command : command -> int -> t -> t
val set_command    : command -> int -> t -> t
val remove_loop    : int -> t -> t
val set_loop       : Dots.t -> int -> t -> t
val remove_arg     : Dots.t -> int -> t -> t
val set_arg        : Dots.t -> command -> int -> t -> t
