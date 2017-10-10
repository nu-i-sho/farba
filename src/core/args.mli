open Common
open Utils

module Die : sig
  type t = private { param : Dots.t;
                       arg : command
                   }
  end
   
module Dies : sig
    module Stage : sig
        type t = private | Stay
                         | Find
                         | Cover
                         | Wait
                         | Uncover
                         | Return
                         
        include SEQUENTIAL.T with type t := t
      end
             
    type t

    val empty      : int -> t
    val make       : int -> command Dots.Map.t -> t
    val section    : t -> int
    val owner      : t -> Energy.Die.t option
    val stage      : t -> Stage.t
    val is_empty   : t -> bool
    val die        : Dots.t -> t -> Die.t
    val die_opt    : Dots.t -> t -> Die.t option
      
    val set_die    : Dots.t -> command -> t -> t
    val remove_die : Dots.t -> t -> t
    val merge      : t -> t -> t
    val next_stage : Energy.Die.t -> t -> t
    val prev_stage : Energy.Die.t -> t -> t
  end

module Dice : sig
    type t

    val empty       : t
    val make        : command Dots.Map.t IntMap.t -> t
    val dies        : int -> Energy.Die.t option -> t -> Dies.t
    val dies_opt    : int -> Energy.Die.t option -> t -> Dies.t option
    val change_dies : int -> Energy.Die.t option ->
                         (Dies.t -> Dies.t) -> t -> t
  end
