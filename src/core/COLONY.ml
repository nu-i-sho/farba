module type T = sig
    type t
	   
    val height : t -> int
    val width  : t -> int
    val get    : (int * int) -> t -> Pigment.t
    val iter   : (Pigment.t -> unit) -> t -> unit
    val iterxy : ((int * int) -> Pigment.t -> unit) -> t -> unit
    val fold   : ('a -> Pigment.t -> 'a) -> 'a -> t -> 'a
    val foldxy : ('a -> (int * int) -> Pigment.t -> 'a)
              -> 'a
              -> t
              -> 'a
  end
