open Common
open Utils

module Die : sig

    module Id : sig
        type t = private int
        module Map : MAPEXT.T with type key = t 
      end
             
    type t

    val id      : t -> Id.t
    val arg     : Dots.t -> t -> command
    val to_list : t -> command list
    val set_arg : Dots.t -> command -> t -> t
  end

module Dice : sig
    type t
     
    val origin  : t
    val dies    : int -> t -> Die.t list
    val add_die : int -> t -> t 
  end
