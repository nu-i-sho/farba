open Utils

module Die : sig
    type t = private Dots.t
    module Map    : MAPEXT.T with type key = t
    module MapOpt : MAPEXT.T with type key = t option
  end

module Dice : sig
    module Mode : sig
        type t =  private | Find of Dots.t
                          | Call 
                          | Return
                          | Stay
      end
         
    type t
   
    val origin    : t
    val mode      : t -> Mode.t
    val top_index : t -> int
    val top_dies  : t -> Die.t list
    val top_die   : t -> Die.t
    val dies      : int -> t -> Die.t list
    val die       : int -> t -> Die.t
    val maybe_die : int -> t -> Die.t option
      
    val with_mode : Mode.t -> t -> t
    val jump      : int -> t -> t
    val step      : t -> t
    val step_back : t -> t
    val back      : t -> t
    val succ      : t -> t
    val pred      : t -> t
  end
