open Utils

module Die : sig
    type t = private | Work of Dots.t * Dots.t
                     | Wait of Dots.t
  end

module Dice : sig
    type t

    val origin    : t
    val die       : int -> t -> Die.t
    val maybe_die : int -> t -> Die.t option

    val set       : int -> Dots.t -> t -> t
    val remove    : int -> t -> t
    val iter      : int -> t -> t
  end
