open Common
open Utils

module Die : sig
    type t
    val param : t -> Dots.t
  end

module Dice : sig
    type t

    val dies      : int -> t -> Die.t list
    val die       : int -> Args.Die.Id.t -> t -> Die.t
    val maybe_die : int -> Args.Die.Id.t -> t -> Die.t option

    val add       : int -> Args.Die.Id.t -> Dots.t -> t -> t
    val remove    : int -> Args.Die.Id.t -> t -> t
  end
