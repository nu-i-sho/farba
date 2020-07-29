module type S = sig
  type t

  val start : Tissue.t -> Source.t -> t
  val step  : t -> t option 
  end
