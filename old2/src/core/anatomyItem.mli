module In : sig
    include module type of Shared.AnatomyItem
  end

module Out : sig
    type t = | Colony of Shared.ColonyItem.t
             | Tissue of TissueItem.Out.t

    val of_in : In.t -> t

  end
