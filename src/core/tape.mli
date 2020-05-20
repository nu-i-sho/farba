module Cell : sig
  type t =
    ( Command.t,
      Dots.t * Energy.Wait.t option,
      Dots.t * Energy.Mark.t option
    ) Statement.t
  end

type t

module Stage : sig
  type t =
    | Call of Energy.Call.t
    | Back of Energy.Back.t
    | Find of Energy.Find.t
  end
   
module Head : sig
  module Link : sig          
    type t =
      | Start
      | Cell of Cell.t 
      | End
    end

  val stage        : t -> Stage.t
  val link         : t -> Link.t
  val change_stage : Stage.t -> t -> t
  val set_wait     : Energy.Wait.t -> t -> t
  val remove_wait  : t -> t
  val mark         : Energy.Mark.t -> t -> t
  val unmark       : t -> t
  val move         : t -> t
  end

val start  : Source.t -> t
val source : t -> Source.t
val cells  : t -> Cell.t list
val cellsi : t -> (int * Cell.t) list
val cell   : int -> t -> Cell.t
val insert : int -> Source.e -> t -> t
val remove : int -> t -> t
