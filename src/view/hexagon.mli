type t

val make : int -> t

module Coord : sig
    val of_index : Index.t -> t -> (int * int) 
end
