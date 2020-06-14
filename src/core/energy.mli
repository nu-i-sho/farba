module type STAGE = sig
  type t
  include IO.S with type t := t
  val value : t -> Dots.t
  end

module Mark : STAGE
module Call : STAGE
module Wait : STAGE
module Back : STAGE
module Find : sig
  include STAGE
  val procedure : t -> Dots.t
  end

val origin    : Call.t
val find      : Dots.t -> Call.t -> Wait.t * Find.t
val call      : Find.t -> Mark.t * Call.t
val back      : Call.t -> Back.t
val not_found : Find.t -> Back.t
val unmark    : Mark.t -> Back.t -> Back.t
val return    : Wait.t -> Back.t -> Call.t
