open Data
   
module type T = sig
    type t

    val length      : t -> int
    val active_item : t -> ProgramActiveItem.t
    val item        : int -> t -> ProgramItem.t
    val maybe_item  : int -> t -> ProgramItem.t option 
    val output      : t -> Action.t option
    val succ        : t -> t 
  end
