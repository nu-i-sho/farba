module Make (Cursor : CURSOR.S) : sig
  include PROCESSOR.S

  val make   : Cursor.t -> Tape.t -> t
  val cursor : t -> Cursor.t
  val tape   : t -> Tape.t
  end
