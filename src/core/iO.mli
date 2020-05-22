module type S = sig
  type t
  val load   : char Seq.t -> (t * char Seq.t) 
  val to_seq : t -> char Seq.t
  end

module OfTissue :
  functor (Tissue : module type of Tissue) ->
  S with type t := Tissue.t
