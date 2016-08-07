module type T = sig
    type t

    val tissue    : t -> Tissue.t
    val turn      : Hand.t -> t -> t
    val move      : t -> t WeavingResult.OfMove.t
    val pass      : t -> t WeavingResult.OfPass.t
    val replicate : Data.Relation.t -> t -> t WeavingResult.OfMove.t
end

module COUNTABLE = struct
    module type T = sig
	include T
	val acts_counter : t -> WeaverActsCounter.t
      end
  end 
