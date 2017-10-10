open Utils

module Die : sig
    type t = private | Work of Dots.t * Dots.t
                     | Wait of Dots.t
  end

module Dice : sig
    type t

    val empty : t
    val make  : Dots.t IntMap.t -> t
      
    val die      : int -> t -> Die.t
    val die_opt  : int -> t -> Die.t option
    val is_empty : t -> bool
      
    val set_die    : int -> Dots.t -> t -> t
    val remove_die : int -> t -> t
    val iter_die   : int -> t -> t
  end
