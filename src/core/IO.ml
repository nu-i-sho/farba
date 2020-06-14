module type S = sig
  type t
  val load   : char Seq.t -> t * char Seq.t
  val unload : t -> char Seq.t
  end
