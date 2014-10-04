module type T = sig

  type t
  type elt

  val hight_of : t -> int
  val width_of : t -> int
  val get      : t -> int * int -> elt
  val set      : t -> int * int -> elt -> unit
  
  val make     : int -> int -> t
  val make_o   : int -> int -> observer:((int * int) -> elt -> unit) -> t 
end
